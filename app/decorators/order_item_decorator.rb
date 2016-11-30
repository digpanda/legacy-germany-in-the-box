class OrderItemDecorator < Draper::Decorator

  delegate_all
  decorates :order_item

  def price_with_currency_euro
    Currency.new(price).display
  end

  def price_with_currency_yuan
    Currency.new(price).to_yuan.display
  end

  def total_price_with_currency_euro
    Currency.new(total_price).display
  end

  def total_price_with_currency_yuan
    Currency.new(total_price).in_euro.to_yuan.display
  end

end
