class OrderItemDecorator < Draper::Decorator

  delegate_all
  decorates :order_item

  def price_with_currency_yuan
    "%.2f#{Settings.instance.platform_currency.symbol}" % price_in_yuan
  end

end