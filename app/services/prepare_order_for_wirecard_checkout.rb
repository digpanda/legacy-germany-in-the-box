#
# Prepare an order to be transmitted to the WireCard server
# Those data will be used for the checkout process and, for instance UnionPay.
#
class PrepareOrderForWirecardCheckout < BaseService

  class << self

    def perform(args={})

      # Should be dynamic
      merchant_id = args[:merchant_id]
      secret_key  = args[:secret_key]
      user        = args[:user]

      wirecard = Wirecard::Customer.new(user, {
        
        :merchant_id  => merchant_id,
        :secret_key   => secret_key,
        :order        => order,

      })

      order_payment             = OrderPayment.new
      order_payment.merchant_id = merchant_id
      order_payment.request_id  = wirecard.request_id
      order_payment.user_id     = user.id # shouldn't be duplicated, but mongoid added it automatically ...
      order_payment.order_id    = order.id
      order_payment.amount      = wirecard.amount
      order_payment.currency    = wirecard.currency
      order_payment.save

      wirecard

    end

  end

end