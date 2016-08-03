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

  # we should definitely use only one system (order or cart) but not both.
  # refactorization needed at some point to avoid duplication
  def tax_and_duty_cost_with_currency_yuan
    Currency.new(tax_and_duty_cost).to_yuan.display
  end

  def shipping_cost_with_currency_yuan
    Currency.new(shipping_cost).to_yuan.display
  end

  def duty_and_shipping_cost_with_currency_yuan
    Currency.new(tax_and_duty_cost + shipping_cost).to_yuan.display
  end

  def total_sum_in_yuan
    Currency.new(total_price).to_yuan.display
  end

  def total_price
    shipping_cost + tax_and_duty_cost + cart_skus_price
  end

  def total_volume
    cart_skus.inject(0) { |sum, cart_skus| sum += cart_skus.volume }
  end

  def cart_skus_price
    cart_skus.inject(0) { |sum, cart_sku| sum += (cart_sku.price * cart_sku.quantity_in_cart) }
  end

end