#
# Prepare an order to be transmitted to the WireCard server
# Those data will be used for the checkout process and, for instance UnionPay.
#
class PrepareOrderForWirecardCheckout < BaseService

  DEBIT_TRANSACTION_TYPE = "debit"

  class << self

    def perform(args={})

      merchant_id = args[:merchant_id]
      secret_key  = args[:secret_key]
      user        = args[:user]
      order       = args[:order]

      wirecard = Wirecard::Hpp.new(user, {

        :merchant_id  => merchant_id,
        :secret_key   => secret_key,
        :order        => order,

      })

      OrderPayment.new.tap do |order_payment|
        order_payment.merchant_id    = merchant_id
        order_payment.request_id     = wirecard.request_id
        order_payment.user_id        = user.id # shouldn't be duplicated, but mongoid added it automatically ...
        order_payment.order_id       = order.id
        order_payment.transaction_type = DEBIT_TRANSACTION_TYPE
        # conversion is done on the fly while creating the payment
        # we store it because it change over time.
        # best would be to update it automatically when the order is paid
        order_payment.payment_method = wirecard.payment_method
        order_payment.save
        # we dynamically set the amount via API response and set the other one via currency exchange
        order_payment.save_origin_amount!(wirecard.amount, wirecard.currency)
        order_payment.refresh_currency_amounts!
      end

      wirecard

    end

  end

end
