CouponHandler.new(current_user, coupon).apply

# destroy / apply coupon and update
# different areas depending on it
class CouponHandler < BaseService

  attr_reader :coupon, :order

  def initialize(coupon, order)
    @coupon = coupon
    @order = order
  end

  def apply
    binding.pry
  end

end
