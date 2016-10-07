# destroy / apply coupon and update
# different areas depending on it
class CouponHandler < BaseService

  attr_reader :coupon, :order

  def initialize(coupon, order)
    @coupon = coupon
    @order = order
  end

  # try to apply the coupon to this specific order
  def apply
    return return_with(:error, I18n.t(:cannot_apply, scope: :coupon)) unless valid_order?
    return return_with(:error, I18n.t(:not_valid_anymore, scope: :coupon)) unless valid_coupon?
    return return_with(:error, I18n.t(:error_occurred_applying, scope: :coupon)) unless update_order! && update_coupon!
    return_with(:success)
  end

  # unapply the coupon to this specific order
  def unapply
    return return_with(:error, I18n.t(:cannot_remove, scope: :coupon)) unless unappliable_order?
    return return_with(:error, I18n.t(:error_occurred_applying, scope: :coupon)) unless reset_order! && reset_coupon!
    return_with(:success)
  end

  # often with AJAX call we change prices on the fly
  # we will need to reset the application to the coupon from here
  def reset
    unapply
    apply
  end

  private

  # all the calculations will be based on the result of this method
  # for more flexibility
  def original_price
    order.total_price
  end

  # order that already bought shouldn't remove any coupon (obviously)
  def unappliable_order?
    order.bought? == false
  end

  # we check for the minimum order price
  # and if the order doesn't have a coupon already
  def valid_order?
    (original_price >= coupon.minimum_order) && (order.coupon.nil?) && (coupon.cancelled_at.nil?)
  end

  # if the coupon is unique it shouldn't have been used already
  def valid_coupon?
    coupon.unique == false || coupon.last_used_at.nil?
  end

  # we unapply the coupon from the order
  def reset_order!
    order.update({
      :coupon_discount => 0,
      :coupon_applied_at => nil,
      :coupon_id => nil
      })
  end

  # we update the order with the correct datas
  def update_order!
    order.update({
      :coupon_discount => coupon_discount,
      :coupon_applied_at => Time.now,
      :coupon_id => coupon.id
      })
  end

  # we consider the coupon as unused
  def reset_coupon!
    coupon.update({:last_used_at => nil})
  end

  # we update the coupon
  def update_coupon!
    coupon.update({:last_used_at => Time.now})
  end

  # we calculate the discount depending on EUR or PERCENT
  def coupon_discount
    if coupon.unit == :value
      coupon.discount
    elsif coupon.unit == :percent
      original_price * coupon.discount / 100
    else
      0
    end
  end

end
