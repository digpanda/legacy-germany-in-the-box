json.data do

  # thanks you mongo for being awesome
  # - Laurent, 27/12/2016
  @order.reload
  @order_item.reload

  # prices
  json.total_price_with_taxes @order.decorate.total_price_with_taxes.in_euro.to_yuan(exchange_rate: @order.exchange_rate).display
  json.shipping_cost @order.decorate.shipping_cost.in_euro.to_yuan(exchange_rate: @order.exchange_rate).display
  json.end_price @order.decorate.end_price.in_euro.to_yuan(exchange_rate: @order.exchange_rate).display
  json.order_empty @order.is_empty?

  # coupon side
  if @order.coupon
    json.total_price_with_extra_costs @order.decorate.total_price_with_extra_costs.in_euro.to_yuan(exchange_rate: @order.exchange_rate).display
    json.total_price_with_discount @order.total_price_with_discount.in_euro.to_yuan(exchange_rate: @order.exchange_rate).display
    json.discount_display @order.coupon.decorate.discount_display
  end

  # order item
  json.order_item do
    json.total_price_with_taxes @order_item.total_price_with_taxes.in_euro.to_yuan(exchange_rate: @order.exchange_rate).display
  end

end

json.success true
