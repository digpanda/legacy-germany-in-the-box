# we update the order payment model depending on a server to server secure query
# this is a double check usually made after the checkout process of our customers.
class WirecardPaymentChecker < BaseService

  attr_reader :transaction_id, :merchant_id, :request_id, :request_amount, :requested_amount_currency
  attr_accessor :order_payment

  def initialize(args)
    @transaction_id = args[:transaction_id]
    @merchant_id    = args[:merchant_account_id]
    @request_id     = args[:request_id]
    @amount         = args[:requested_amount]
    @currency       = args[:requested_amount_currency]
    @order_payment  = OrderPayment.where({merchant_id: merchant_id, request_id: request_id, amount: amount, currency: currency}).first
  end

  def update_order_payment!
    checking_order_payment!
    order_payment.status = transaction_status
    order_payment.save
  end

  def checking_order_payment!
    order_payment.status         = :checking
    order_payment.transaction_id = transaction_id
    order_payment.save
  end

  private

  def transaction_status
    Wirecard::ElasticApi.transaction(merchant_id, transaction_id).status
  rescue Wirecard::Api::Error
    :corrupted
  end

end
