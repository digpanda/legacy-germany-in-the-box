class OrderDecorator < Draper::Decorator

  include OrderCartDecoratorCommon

  delegate_all
  decorates :order

  def total_sum_with_currency
    "%.2f#{Settings.instance.platform_currency.symbol}" % (total_price_in_yuan + shipping_cost_in_yuan + tax_and_duty_cost_in_yuan)
  end

  def total_price_with_currency
    "%.2f#{Settings.instance.platform_currency.symbol}" % total_price_in_yuan
  end

  def shipping_cost_with_currency
    "%.2f#{Settings.instance.platform_currency.symbol}" % shipping_cost_in_yuan
  end

  def tax_and_duty_cost_with_currency
    "%.2f#{Settings.instance.platform_currency.symbol}" % tax_and_duty_cost_in_yuan
  end

  # DON'T EXIST ANYMORE ? - Laurent on 29/06/2016
  def is_success?
    self.status == :success
  end

  def paid?
    ([:new, :paying].include? self.status) == false
  end

end