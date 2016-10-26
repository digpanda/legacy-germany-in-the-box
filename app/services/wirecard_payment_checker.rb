# we update the order payment model depending on a server to server secure query
# this is a double check usually made after the checkout process of our customers.
class WirecardPaymentChecker < BaseService

  VALID_FINALIZED_TRANSACTION_STATE = [:debit, :purchase, :'refund-purchase', :'refund-debit']

  attr_reader :transaction_id, :merchant_id, :request_id, :payment_method
  attr_accessor :order_payment

  def initialize(args)
    @order_payment  = args[:order_payment]
    @transaction_id = args[:transaction_id] || order_payment.transaction_id
    @merchant_id    = args[:merchant_account_id] || order_payment.merchant_id
    @request_id     = args[:request_id] || order_payment.request_id
    @payment_method = args[:payment_method] || order_payment.payment_method
  end
  
  def update_order_payment!
    unverified_order_payment!
    # originally silent error turned into a raise error to be more clear
    # it won't get the transaction detail if it's not a purchase / debit
    unless finalized_transaction?
      raise Wirecard::Elastic::Error, "Transaction type is not valid. Please verify you used the correct transaction-id (#{remote_transaction.response.transaction_type})"
    end
    # this part can raise errors easily
    refresh_order_payment_from_api!
    # this was already set at some point in the system
    # we just update the payment in case the currency conversion
    # would different between the order and payment time
    order_payment.refresh_currency_amounts!
    return_with(:success)
  rescue Wirecard::Elastic::Error => exception
    return_with(:error, exception)
  end

  private

  # force the unverified status for this payment
  def unverified_order_payment!
    order_payment.status         = :unverified
    order_payment.transaction_id = transaction_id
    order_payment.save
  end

  # get the remote transaction and raise error in case the connection isn't correctly established
  # or the transaction has basically failed
  def remote_transaction
    @remote_transaction ||= Wirecard::Elastic.transaction(merchant_id, transaction_id, payment_method).raise_response_issues
  end

  # the elastic API can reply positively even if it's a simple `get-url` transaction
  # it can occur if someone put a get url transaction id by mistake which would
  # set a false positive (:success) so we better check it's in the correct transaction type.
  def finalized_transaction?
    VALID_FINALIZED_TRANSACTION_STATE.include?(remote_transaction.response.transaction_type)
  end

  def refresh_order_payment_from_api!
    order_payment.status = remote_transaction.response.transaction_state
    order_payment.payment_method = remote_transaction.response.payment_method
    order_payment.save
  end

end
