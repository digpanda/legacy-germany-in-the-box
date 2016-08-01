class CartDecorator < Draper::Decorator

  include OrderCartDecoratorCommon

  delegate_all
  decorates :cart

  def add(sku, quantity)
    cart_skus << CartSku.new(
      sku: sku,
      quantity_in_cart: quantity
    )
  end

  # not currently in use in the real system (but still in tests)
  def create_order(options = {})
    order_line_items = cart_skus.map(&:becomes_order_line_item)

    Order.new({
      border_guru_quote_id: border_guru_quote_id,
      order_items: order_line_items,
      shipping_cost: shipping_cost,
      tax_and_duty_cost: tax_and_duty_cost
    }.merge(options))
  end
  
  # should be refactored via the currency system
  def tax_and_duty_cost_with_currency_yuan
    "%.2f #{Settings.instance.platform_currency.symbol}" % (in_yuan(object.tax_and_duty_cost))
  end

  def shipping_cost_with_currency_yuan
    "%.2f #{Settings.instance.platform_currency.symbol}" % (in_yuan(object.shipping_cost))
  end

  def duty_and_shipping_cost_with_currency_yuan
    "%.2f #{Settings.instance.platform_currency.symbol}" % (in_yuan(object.tax_and_duty_cost) + (in_yuan(object.shipping_cost)))
  end

  def total_sum_in_yuan
    "%.2f #{Settings.instance.platform_currency.symbol}" % total_price_in_yuan
  end

  private

  # COULD BE IMPROVED WAY MORE BY USING A GEM OR ABSTRACTING IT ELSEWHERE
  def in_yuan(price)
    price * Settings.instance.exchange_rate_to_yuan
  end

end