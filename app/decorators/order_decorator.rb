class OrderDecorator < Draper::Decorator

  include OrderCartDecoratorCommon

  delegate_all
  decorates :order

  def is_bought?
    not [:new, :paying].include?(self.status)
  end

  def total_price
    if self.is_bought?
      order_items.inject(0) { |sum, i| sum += i.quantity * i.price }
    else
      order_items.inject(0) { |sum, i| sum += i.quantity * i.sku.price }
    end
  end

  def total_price_in_yuan
    Currency.new(total_price).to_yuan.amount
  end

  def total_sum
    total_price.to_f + shipping_cost.to_f + tax_and_duty_cost.to_f
  end

  def total_price_with_currency_euro
    Currency.new(total_price).display
  end

  def total_sum_in_yuan
    Currency.new(total_sum).to_yuan.display
  end

  def total_sum_in_euro
    Currency.new(total_sum).display
  end

  def reach_todays_limit?(new_price_increase, new_quantity_increase)
    if order_items.size == 0 && new_quantity_increase == 1
      false
    elsif order_items.size == 1 && new_quantity_increase == 0
      false
    else
      (total_price_in_yuan + new_price_increase) > Settings.instance.max_total_per_day
    end
  end

  def total_quantity
    order_items.inject(0) { |sum, order_item| sum += order_item.quantity }
  end

  def total_volume
    order_items.inject(0) { |sum, order_item| sum += order_item.volume }
  end

  def processable?
    status == :paid && processable_time?
  end

  def processable_time?
    Time.now.strftime("%k").to_i < 9 || Time.now.strftime("%k").to_i > 10
  end

  def shippable?
    self.status == :custom_checking && Time.now > minimum_sending_date
  end

  def total_price_with_currency_yuan
    Currency.new(total_price).to_yuan.display
  end

  def shipping_cost_with_currency_yuan
    Currency.new(shipping_cost).to_yuan.display
  end

  def shipping_cost_with_currency_euro
    Currency.new(shipping_cost).display
  end

  def tax_and_duty_cost_with_currency_yuan
    Currency.new(tax_and_duty_cost).to_yuan.display
  end

  def tax_and_duty_cost_with_currency_euro
    Currency.new(tax_and_duty_cost).display
  end

  # DON'T EXIST ANYMORE ? - Laurent on 29/06/2016
  def is_success?
    self.status == :success
  end

  def paid?
    ([:new, :paying].include? self.status) == false
  end

end