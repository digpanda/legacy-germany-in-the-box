json.data do

  json.amount_in_carts @total_number_of_products
  json.total_price_with_currency_yuan @order.decorate.total_price_with_currency_yuan
  json.tax_and_duty_cost_with_currency_yuan @order.decorate.tax_and_duty_cost_with_currency_yuan
  json.shipping_cost_with_currency_yuan @order.decorate.shipping_cost_with_currency_yuan
  json.duty_and_shipping_cost_with_currency_yuan @order.decorate.duty_and_shipping_cost_with_currency_yuan
  json.total_price_with_extra_costs_in_yuan @order.decorate.total_price_with_extra_costs_in_yuan

end

json.success true
