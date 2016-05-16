class OrderDecorator < Draper::Decorator

  delegate_all
  decorates :order

  def total_price_in_currency(currency_code)
    "#{object.total_price} #{currency_code}"
  end

end