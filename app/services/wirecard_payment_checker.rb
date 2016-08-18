# we update the order payment model depending on a server to server secure query
# this is a double check usually made after the checkout process of our customers.
class WirecardPaymentChecker < BaseService

  attr_reader :transaction_id, :merchant_id, :request_id
  attr_accessor :order_payment

  def initialize(args)
    @transaction_id = args[:transaction_id]
    @merchant_id    = args[:merchant_account_id]
    @request_id     = args[:request_id]
    @order_payment  = OrderPayment.where({merchant_id: merchant_id, request_id: request_id}).first
    # TODO : make protection here in case we can't recover this transaction
  end

  def update_order_payment!
    unverified_order_payment!
    if remote_transaction # a problem occurred ... we should actually tell the admin and put back the info to the controller
      order_payment.status = remote_transaction.status
      order_payment.payment_method = remote_transaction.method
      order_payment.save
    end
    # this was already set at some point in the system
    # we just update the payment in case the currency conversion
    # would different between the order and payment time
    order_payment.refresh_currency_amounts!
  end

  def unverified_order_payment!
    order_payment.status         = :unverified
    order_payment.transaction_id = transaction_id
    order_payment.save
  end

  private

  def remote_transaction
    @remote_transaction ||= Wirecard::ElasticApi.transaction(merchant_id, transaction_id).raise_response_issues
  rescue Wirecard::ElasticApi::Error
    false # instead of this we could return_with after the raise or something like that so we have the exact reason put to the controller
  end

end
