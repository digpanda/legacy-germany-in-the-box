class OrderItemDecorator < Draper::Decorator

  delegate_all
  decorates :order_item

  def unit_price_in_currency(currency_code)
    "#{object.price} #{currency_code}"
  end

end