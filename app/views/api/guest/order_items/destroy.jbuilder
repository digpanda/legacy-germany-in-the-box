json.data do

  # NOTE : we don't reload the @order because
  # there's a chance it doesn't exist anymore
  # be careful about that.
  if @order.persisted?

    @order.reload

    # prices
    json.total_price_with_taxes @order.decorate.total_price_with_taxes.in_euro.to_yuan.display
    json.shipping_cost @order.decorate.shipping_cost.in_euro.to_yuan.display
    json.end_price @order.decorate.end_price.in_euro.to_yuan.display
    json.order_empty @order.is_empty?

    # coupon side
    if @order.coupon
      json.total_price_with_extra_costs @order.decorate.total_price_with_extra_costs.in_euro.to_yuan.display
      json.total_price_with_discount @order.total_price_with_discount.in_euro.to_yuan.display
      json.discount_display @order.coupon.decorate.discount_display
    end

  end

end

json.order_empty !@order.persisted?
json.success true
