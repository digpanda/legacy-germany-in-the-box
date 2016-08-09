#
# We update the order payment model depending on a server to server secure query
# This is a double check usually made after the checkout process of our customers.
#
class UpdateOrderAndPaymentFromWirecardTransaction < BaseService

  class << self

    def perform(args={})

      transaction_id = args[:transaction_id]
      merchant_id    = args[:merchant_account_id]
      request_id     = args[:request_id]
      amount         = args[:requested_amount]
      currency       = args[:requested_amount_currency]

      # we find the order payment
      order_payment                = OrderPayment.where({merchant_id: merchant_id, request_id: request_id, amount: amount, currency: currency}).first
      order_payment.status         = :checking
      order_payment.transaction_id = transaction_id
      order_payment.save

      wirecard = Wirecard::Reseller.new({

        :merchant_id  => merchant_id,

      })

      # we update the order payment depending on the REAL server side state
      transaction = wirecard.transaction(transaction_id)
      order_payment.status = wirecard.payment_status(transaction)
      order_payment.save
      
    end

  end

end
