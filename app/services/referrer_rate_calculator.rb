class ReferrerRateCalculator
  attr_reader :order_item

  # the calculation is needed from order item level
  # please be aware of that.
  def initialize(order_item)
    @order_item = order_item
  end

  def solve
    return 0.0 unless referrer
    
    if package_set
      return solve_rate package_set
    end

    if product
      return solve_rate product
    end

    # NOTE : not sure if this will ever occurs
    # but we can still display it from this service.
    if service
      return solve_rate service
    end

    0.0
  end

  def solve_rate(model_entry)
    case referrer.user.group
    when :junior
      model_entry.junior_referrer_rate
    when :senior
      model_entry.senior_referrer_rate
    else
      model_entry.default_referrer_rate
    end
  end

  def referrer
    @parent_referrer ||= order_item.order.user.parent_referrer
  end

  def package_set
    order_item.package_set
  end

  def product
    order_item.product
  end

end
