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
    # TODO : make protection here in case we can't recover this transaction -> or we could call the service directly via the order_payment which makes things way lighter
  end

  def update_order_payment!
    unverified_order_payment!
    refresh_order_payment_from_api! # this part can raise errors easily
    # this was already set at some point in the system
    # we just update the payment in case the currency conversion
    # would different between the order and payment time
    order_payment.refresh_currency_amounts!
    return_with(:success)
  rescue Wirecard::ElasticApi::Error => exception
    return_with(:error, exception)
  end

  def unverified_order_payment!
    order_payment.status         = :unverified
    order_payment.transaction_id = transaction_id
    order_payment.save
  end

  private

  # get the remote transaction and raise error in case the connection isn't correctly established
  # or the transaction has basically failed
  def remote_transaction
    @remote_transaction ||= Wirecard::ElasticApi.transaction(merchant_id, transaction_id).raise_response_issues
  end

  def refresh_order_payment_from_api!
    order_payment.status = remote_transaction.response.status
    order_payment.payment_method = remote_transaction.response.payment_method
    order_payment.save
  end

end
