class OrderItemDecorator < Draper::Decorator

  delegate_all
  decorates :order_item

  def price_with_currency_yuan
    "%.2f#{Settings.instance.platform_currency.symbol}" % price_in_yuan
  end

  def total_price_with_currency_euro
    "%.2f#{Settings.instance.supplier_currency.symbol}" % total_price
  end

end