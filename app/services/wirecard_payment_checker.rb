# we update the order payment model depending on a server to server secure query
# this is a double check usually made after the checkout process of our customers.
class WirecardPaymentChecker < BaseService

  attr_reader :transaction_id, :merchant_id, :request_id, :amount, :currency
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
    order_payment.status = remote_transaction.status
    order_payment.transaction_type = remote_transaction.type
    order_payment.save
  end

  def checking_order_payment!
    order_payment.status         = :checking
    order_payment.transaction_id = transaction_id
    order_payment.save
  end

  private

  def remote_transaction
    Wirecard::ElasticApi.transaction(merchant_id, transaction_id).request!
  rescue Wirecard::ElasticApi::Error
    # could be improved : "debit" is a very manual way to go.
    # we may prefer to the `transaction_type` before the transaction to avoid this kind of static data
    Struct.new(:status, :type).new(:corrupted, "debit")
  end

end
