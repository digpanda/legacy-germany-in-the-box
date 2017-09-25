class CouponDecorator < Draper::Decorator
  delegate_all
  decorates :coupon

  # NOTE : this is not in use anymore (supposedly)
  # please check the to_yuan currency exchange if not
  def discount_display
    if unit == :percent
      "-#{discount.to_i}%"
    else
      "-#{discount.in_euro.to_yuan.display}"
    end
  end
end
