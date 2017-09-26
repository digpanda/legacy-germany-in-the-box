class CheckoutGateway
  class Base
    # we either match an exact equivalent order payment which means
    # we already tried to pay but failed at any point of the process
    # before the `:scheduled` status changed
    def order_payment
      @order_payment ||= (recovered_order_payment || OrderPayment.new)
    end

    # may return nil
    def recovered_order_payment
      OrderPayment.where(
        order_id: order.id,
        status: :scheduled,
        user_id: user.id
      ).first
    end

    def prepare_order_payment!
      order_payment.tap do |order_payment|
        order_payment.user_id          = user.id
        order_payment.order_id         = order.id
        order_payment.status           = :scheduled
        order_payment.payment_method   = payment_gateway.payment_method
        order_payment.transaction_type = :debit # TODO : make it dynamic ?
        order_payment.save
        order_payment.save_origin_amount!(order.end_price.in_euro.to_yuan(exchange_rate: order.exchange_rate).amount, 'CNY')
        order_payment.refresh_currency_amounts!
      end
    end
  end
end
