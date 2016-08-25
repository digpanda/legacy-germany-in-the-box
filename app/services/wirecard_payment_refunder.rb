# we refund people here
class WirecardPaymentRefunder < BaseService

  # TODO : there's a replication here, we should improve this
  REFUND_MAP = {:purchase => :'refund-purchase', :debit => :'refund-debit'}

  attr_reader :order_payment

  def initialize(order_payment)
    @order_payment = order_payment
  end

  def perform
    raise_potential_issues
    create_refund_order_payment
    return_with(:success)
  rescue WirecardPaymentRefunder::Error => exception
    return_with(:error, exception)
  end

  private

  def response
    # TODO : refactor and don't consider the raw amount but use the ResponseFormat class to handle this
    @response ||= Wirecard::ElasticApi.refund(order_payment.merchant_id, order_payment.transaction_id).response.raw
  rescue Wirecard::ElasticApi::Error
    raise Error, "A problem occured while trying to refund this transaction"
  end

  def raise_potential_issues
    raise Error, "This transaction has already been refunded" if already_refunded?
    raise Error, "The API could not refund this customer" unless transaction_success?
  end

  def create_refund_order_payment
    OrderPayment.new.tap do |order_payment_refund|
      order_payment_refund.merchant_id      = order_payment.merchant_id
      order_payment_refund.request_id       = response[:payment][:"request-id"]
      order_payment_refund.transaction_id   = response[:payment][:"transaction-id"]
      order_payment_refund.parent_transaction_id = order_payment.transaction_id
      order_payment_refund.transaction_type = response[:payment][:"transaction-type"]
      order_payment_refund.user_id          = order_payment.user_id
      order_payment_refund.order_id         = order_payment.order_id
      order_payment_refund.payment_method   = order_payment.payment_method
      order_payment_refund.status           = :success
      order_payment_refund.save
      # we dynamically set the amount via API response and set the other one via currency exchange
      order_payment_refund.save_origin_amount!(response[:payment][:"requested-amount"][:"value"], response[:payment][:"requested-amount"][:"currency"])
      order_payment_refund.refresh_currency_amounts!
    end
  end

  def already_refunded?
    OrderPayment.where({
      merchant_id: order_payment.merchant_id,
      parent_transaction_id: order_payment.transaction_id,
      transaction_type: response[:payment][:"transaction-type"]}).first
  end

  def transaction_success?
    #ExceptionNotifier.notify_exception(Wirecard::Base::Error.new, :env => Rails.env, :data => response)
    response[:payment][:"transaction-state"] == "success"
  end

end
