class CartDecorator < Draper::Decorator
  delegate_all
  decorates :cart

  def duty_cost_with_currency
    "%.2f #{Settings.instance.platform_currency.symbol}" % (object.tax_and_duty_cost * Settings.instance.exchange_rate_to_yuan)
  end

  def shipping_cost_with_currency
    "%.2f #{Settings.instance.platform_currency.symbol}" % (object.shipping_cost * Settings.instance.exchange_rate_to_yuan)
  end

  def total_in_yuan
    sum = (shipping_cost + tax_and_duty_cost + cart_skus.inject(0) { |sum, s| sum += (s.price * s.quantity_in_cart) }) * Settings.instance.exchange_rate_to_yuan
    sum.round(2)
  end

  def total_with_currency
    "%.2f #{Settings.instance.platform_currency.symbol}" % total_in_yuan
  end

end