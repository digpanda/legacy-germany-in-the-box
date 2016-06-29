class CartDecorator < Draper::Decorator

  include OrderCartDecoratorCommon

  delegate_all
  decorates :cart

  def tax_and_duty_cost_with_currency
    "%.2f #{Settings.instance.platform_currency.symbol}" % (in_yuan(object.tax_and_duty_cost))
  end

  def shipping_cost_with_currency
    "%.2f #{Settings.instance.platform_currency.symbol}" % (in_yuan(object.shipping_cost))
  end

  def duty_and_shipping_cost_with_currency
    "%.2f #{Settings.instance.platform_currency.symbol}" % (in_yuan(object.tax_and_duty_cost) + (in_yuan(object.shipping_cost)))
  end

  def total_sum_with_currency
    "%.2f #{Settings.instance.platform_currency.symbol}" % total_price_in_yuan
  end

  private

  # COULD BE IMPROVED WAY MORE BY USING A GEM OR ABSTRACTING IT ELSEWHERE
  def in_yuan(price)
    price * Settings.instance.exchange_rate_to_yuan
  end

end