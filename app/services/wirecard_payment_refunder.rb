# we refund people here
class WirecardPaymentRefunder < BaseService

  REFUND_TRANSACTION_TYPE = "refund"

  attr_reader :order_payment

  def initialize(order_payment)
    @order_payment = order_payment
  end

  def perform!
    return_with(:error, "This transaction has already been refunded") if already_refunded?
    if request_refund.success?
      create_refund_order_payment(request_refund.data)
      return_with(:success)
    else
      request_refund
    end
  end

  def create_refund_order_payment(response)
    OrderPayment.new.tap do |order_payment|
      order_payment.merchant_id    = order_payment.merchant_id
      order_payment.request_id     = response[:"request-id"]
      order_payment.transaction_id = response[:"transaction-id"]
      order_payment.transaction_type = REFUND_TRANSACTION_TYPE
      order_payment.user_id        = order_payment.user_id
      order_payment.order_id       = order_payment.order_id
      order_payment.payment_method = order_payment.payment_method
      order_payment.save
      # we dynamically set the amount via API response and set the other one via currency exchange
      order_payment.save_origin_amount!(response[:"requested-amount"][:"value"], response[:"requested-amount"][:"currency"])
      order_payment.refresh_currency_amounts!
    end
  end

  private

  def already_refunded?
    OrderPayment.where(merchant_id: order_payment.merchant_id, parent_transaction_id: order_payment.transaction_id, transaction_type: REFUND_TRANSACTION_TYPE).first
  end

  def request_refund
    @request_refund ||= begin
      response = Wirecard::ElasticApi.refund(order_payment.merchant_id, order_payment.transaction_id).response
      if response[:payment][:"transaction-state"] == "success"
        return_with(:success, response[:payment])
      else
        return_with(:error, "The API could not refund this customer")
      end
    end
  rescue Wirecard::ElasticApi::Error
    return_with(:error, "We problem occured while trying to refund this transaction")
  end

end
