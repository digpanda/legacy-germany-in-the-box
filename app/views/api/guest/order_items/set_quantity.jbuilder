json.data do

  json.amount_in_carts @total_number_of_products
  json.total_price_with_currency @order.decorate.total_price_with_currency
  json.tax_and_duty_cost_with_currency @current_cart.decorate.tax_and_duty_cost_with_currency
  json.shipping_cost_with_currency @current_cart.decorate.shipping_cost_with_currency
  json.total_price_with_currency @current_cart.decorate.total_price_with_currency

end

json.success true
