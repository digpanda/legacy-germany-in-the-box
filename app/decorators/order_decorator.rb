require "abstract_method"

class OrderDecorator < Draper::Decorator

  MAX_DESCRIPTION_CHARACTERS = 200

  abstract_method :tax_and_duty_cost_with_currency_yuan, :shipping_cost_with_currency_yuan, :total_price_with_extra_costs_in_yuan

  delegate_all
  decorates :order

  def clean_desc
    if desc
      Cleaner.slug(desc)
    end
  end

  def clean_order_items_description
    self.order_items.reduce(&:clean_desc).join(', ')
  end

  def total_price_in_yuan
    Currency.new(total_price).to_yuan.amount
  end

  def total_price_with_currency_euro
    Currency.new(total_price).display
  end

  def total_price_with_extra_costs_in_yuan
    Currency.new(total_price_with_extra_costs).to_yuan.display
  end

  def total_price_with_extra_costs_in_euro
    Currency.new(total_price_with_extra_costs).display
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
