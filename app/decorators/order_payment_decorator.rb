class OrderPaymentDecorator < Draper::Decorator

  delegate_all
  decorates :address

  def amount_with_currency
    "#{order_payment.amount} #{order_payment.currency.code}"
  end

end

