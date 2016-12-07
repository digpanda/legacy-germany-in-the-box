json.data do

  # prices
  json.total_price @order.decorate.total_price.in_euro.to_yuan.display
  json.tax_and_shipping_cost @order.decorate.extra_costs.in_euro.to_yuan.display
  json.end_price @order.decorate.end_price.in_euro.to_yuan.display

  # discount side
  unless @order.coupon.nil?
    json.total_price_with_extra_costs @order.decorate.total_price_with_extra_costs.in_euro.to_yuan.display
    json.total_price_with_discount @order.decorate.total_price_with_discount.in_euro.to_yuan.display
    json.discount_display @order.coupon.decorate.discount_display
  end

end

json.success true
