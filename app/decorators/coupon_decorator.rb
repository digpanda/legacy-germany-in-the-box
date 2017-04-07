class CouponDecorator < Draper::Decorator

  delegate_all
  decorates :coupon

  def discount_display
    if unit == :percent
      "-#{discount.to_i}%"
    else
      "-#{discount.in_euro.to_yuan.display}"
    end
  end

end
