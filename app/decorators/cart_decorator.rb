class CartDecorator < Draper::Decorator

  include OrderCartDecoratorCommon

  delegate_all
  decorates :cart

  def tax_and_duty_cost_with_currency
    "%.2f #{Settings.instance.platform_currency.symbol}" % (object.tax_and_duty_cost * Settings.instance.exchange_rate_to_yuan)
  end

  def shipping_cost_with_currency
    "%.2f #{Settings.instance.platform_currency.symbol}" % (object.shipping_cost * Settings.instance.exchange_rate_to_yuan)
  end

  def total_sum_with_currency
    "%.2f #{Settings.instance.platform_currency.symbol}" % total_price_in_yuan
  end

end