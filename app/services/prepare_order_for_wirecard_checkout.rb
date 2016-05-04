class PrepareOrderForWirecardCheckout

  class << self

    def perform(args={})

      # Should be dynamic @yl
      merchant_id = args[:merchant_id]
      secret_key  = args[:secret_key]
      user = args[:user]
      order = args[:order]
      amount = args[:amount]
      currency = args[:currency]

      wirecard = Wirecard::Customer.new(user, {
        
        :merchant_id  => merchant_id,
        :secret_key   => secret_key,
        
        :order_number => order.id,
        
        :amount       => amount,
        :currency     => currency,
        :order_detail => order.desc,

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