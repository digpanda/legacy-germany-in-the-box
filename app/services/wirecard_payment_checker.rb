# we update the order payment model depending on a server to server secure query
# this is a double check usually made after the checkout process of our customers.
class WirecardPaymentChecker < BaseService

  VALID_FINALIZED_TRANSACTION_STATE = [:debit, :purchase]

  attr_reader :transaction_id, :merchant_id, :request_id
  attr_accessor :order_payment

  def initialize(args)
    @transaction_id = args[:transaction_id]
    @merchant_id    = args[:merchant_account_id]
    @request_id     = args[:request_id]
    @order_payment  = args[:order_payment]
  end

  def update_order_payment!
    unverified_order_payment!
    # originally silent error turned into a raise error to be more clear
    # it won't get the transaction detail if it's not a purchase / debit
    unless finalized_transaction?
      raise Wirecard::ElasticApi::Error, "Transaction type is not valid. Please verify you used the correct transaction-id"
    end
    # this part can raise errors easily
    refresh_order_payment_from_api!
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

  # the elastic API can reply positively even if it's a simple `get-url` transaction
  # it can occur if someone put a get url transaction id by mistake which would
  # set a false positive (:success) so we better check it's in the correct transaction type.
  def finalized_transaction?
    VALID_FINALIZED_TRANSACTION_STATE.include?(remote_transaction.response.transaction_type)
  end

  def refresh_order_payment_from_api!
    order_payment.status = remote_transaction.response.status
    order_payment.payment_method = remote_transaction.response.payment_method
    order_payment.save
  end

end
