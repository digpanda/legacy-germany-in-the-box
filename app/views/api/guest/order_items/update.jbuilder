json.data do

  json.amount_in_carts @total_number_of_products
  json.total_price_with_currency_yuan @order.decorate.total_price_with_currency_yuan
  json.tax_and_duty_cost_with_currency_yuan @current_cart.decorate.tax_and_duty_cost_with_currency_yuan
  json.shipping_cost_with_currency_yuan @current_cart.decorate.shipping_cost_with_currency_yuan
  json.duty_and_shipping_cost_with_currency_yuan @current_cart.decorate.duty_and_shipping_cost_with_currency_yuan
  json.total_sum_in_yuan @current_cart.decorate.total_sum_in_yuan

end

json.success true
