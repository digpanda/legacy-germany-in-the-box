require "abstract_method"

module OrderCartDecoratorCommon
  abstract_method :tax_and_duty_cost_with_currency, :shipping_cost_with_currency, :total_sum_with_currency
end