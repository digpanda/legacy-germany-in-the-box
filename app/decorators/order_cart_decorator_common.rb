require "abstract_method"

module OrderCartDecoratorCommon
  abstract_method :tax_and_duty_cost_with_currency_yuan, :shipping_cost_with_currency_yuan, :total_sum_in_yuan
end