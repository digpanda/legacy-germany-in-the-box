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
    @response ||= Wirecard::Elastic.refund(order_payment.merchant_id, order_payment.transaction_id, order_payment.payment_method).response
  rescue Wirecard::Elastic::Error
    raise Error, "A problem occured while trying to refund this transaction"
  end

  def raise_potential_issues
    raise Error, "This transaction has already been refunded" if already_refunded?
    raise Error, "The API could not refund this customer" unless transaction_success?
  end

  def create_refund_order_payment
    OrderPayment.new.tap do |order_payment_refund|
      order_payment_refund.merchant_id      = order_payment.merchant_id
      order_payment_refund.request_id       = response.request_id
      order_payment_refund.transaction_id   = response.transaction_id
      order_payment_refund.parent_transaction_id = order_payment.transaction_id
      order_payment_refund.transaction_type = response.transaction_type
      order_payment_refund.user_id          = order_payment.user_id
      order_payment_refund.order_id         = order_payment.order_id
      order_payment_refund.payment_method   = order_payment.payment_method
      # TODO: refactor this
      if transaction_success?
        order_payment_refund.status = response.transaction_state
      else
        order_payment_refund.status = :failed
      end
      order_payment_refund.save
      # we dynamically set the amount via API response and set the other one via currency exchange
      order_payment_refund.save_origin_amount!(response.requested_amount, response.requested_amount_currency)
      order_payment_refund.refresh_currency_amounts!
    end
  end

  def already_refunded?
    OrderPayment.where({
      merchant_id: order_payment.merchant_id,
      parent_transaction_id: order_payment.transaction_id,
      transaction_type: response.transaction_type}).first
  end

  def transaction_success?
    response.transaction_state == :success
  end

end
