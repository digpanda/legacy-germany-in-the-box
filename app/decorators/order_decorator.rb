require "abstract_method"

class OrderDecorator < Draper::Decorator

  MAX_DESCRIPTION_CHARACTERS = 200

  abstract_method :tax_and_duty_cost_with_currency_yuan, :shipping_cost_with_currency_yuan, :total_sum_in_yuan

  delegate_all
  decorates :order

  def clean_desc
    return '' if self.desc.nil?
    self.desc.squish.downcase.gsub(',', '')
  end

  def clean_order_items_description
    self.order_items.reduce([]) { |acc, order_item| acc << "#{order_item.product.name}: #{order_item.product.decorate.clean_desc(MAX_DESCRIPTION_CHARACTERS)}" }.join(', ')
  end

  def total_price_in_yuan
    Currency.new(total_price).to_yuan.amount
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

  def total_price_with_currency_yuan
    total_price.in_euro.to_yuan.display
  end

  def duty_and_shipping_cost_with_currency_euro
    (tax_and_duty_cost + shipping_cost).in_euro.display
  end

  def duty_and_shipping_cost_with_currency_yuan
    (tax_and_duty_cost + shipping_cost).in_euro.to_yuan.display
  end

  def shipping_cost_with_currency_yuan
    shipping_cost.in_euro.to_yuan.display
  end

  def shipping_cost_with_currency_euro
    shipping_cost.in_euro.display
  end

  def tax_and_duty_cost_with_currency_yuan
    tax_and_duty_cost.in_euro.to_yuan.display
  end

  def tax_and_duty_cost_with_currency_euro
    tax_and_duty_cost.in_euro.display
  end

end
