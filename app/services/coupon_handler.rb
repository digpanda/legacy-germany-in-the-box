# destroy / apply coupon and update
# different areas depending on it
class CouponHandler < BaseService
  attr_reader :identity_solver, :coupon, :order

  EXPIRE_APPLY_TIME = 10.hours.freeze

  def initialize(identity_solver, coupon, order)
    @identity_solver = identity_solver
    @coupon = coupon
    @order = order
  end

  # try to apply the coupon to this specific order
  def apply
    unless reached_minimum_order?
      return return_with(:error, I18n.t('coupon.no_minimum_price', minimum: coupon.minimum_order.in_euro.to_yuan(exchange_rate: coupon.order.exchange_rate).display))
    end
    return return_with(:error, "You can't apply this coupon from China.") unless valid_ip?
    return return_with(:error, "You can't apply this coupon on this user.") unless valid_user?
    return return_with(:error, "You can't apply this coupon on this shop.") unless valid_shop?
    return return_with(:error, I18n.t('coupon.cannot_apply')) unless valid_order?
    return return_with(:error, I18n.t('coupon.not_valid_anymore')) unless valid_coupon?
    return return_with(:error, I18n.t('coupon.error_occurred_applying')) unless update_order! && update_referrer! && update_coupon!
    return_with(:success)
  end

  # unapply the coupon to this specific order
  def unapply
    return return_with(:error, I18n.t('coupon.cannot_remove')) unless unappliable_order?
    return return_with(:error, I18n.t('coupon.error_occurred_applying')) unless reset_order! && reset_coupon!
    return_with(:success)
  end

  # often with AJAX call we change prices on the fly
  # we will need to reset the application to the coupon from here
  def reset
    unapply
    apply
  end

  def reset_status
    reset_coupon!
  end

  # we unapply the coupon from the order
  def reset_order!
    order.update(
      coupon_discount:   0,
      coupon_applied_at: nil,
      coupon_id:         nil
      )
  end

  # we update the order with the correct datas
  def update_order!
    order.update(
      coupon_discount:   coupon_discount,
      coupon_applied_at: Time.now,
      coupon_id:         coupon.id
      )
  end

  # if there's no user referrer linked to this ore
  # we try to refresh with the coupon referrer if it exists
  def update_referrer!
    if order.referrer && order.referrer_origin == :user
      true
    elsif coupon.referrer
      order.update(
        referrer:        coupon.referrer,
        referrer_origin: :coupon
      )
    else
      true
    end
  end

  # we update the coupon
  def update_coupon!
    coupon.update(last_applied_at: Time.now)
  end

  # we consider the coupon as unused
  def reset_coupon!
    coupon.update(last_applied_at: nil)
  end

  private

    # all the calculations will be based on the result of this method
    # for more flexibility
    def original_price
      order.total_price_with_taxes
    end

    # order that already bought shouldn't remove any coupon (obviously)
    def unappliable_order?
      order.bought? == false
    end

    # we check for the minimum order price
    # and if the order doesn't have a coupon already
    def valid_order?
      reached_minimum_order? && order.coupon.nil? && coupon.cancelled_at.nil?
    end

    # if we want to exclude chinese IPs
    def valid_ip?
      (coupon.exclude_china && !identity_solver.chinese_ip?) || !coupon.exclude_china
    end

    def valid_user?
      coupon.user_id == order.user.id || !coupon.user
    end

    def valid_shop?
      coupon.shop_id == order.shop.id || !coupon.shop
    end

    def reached_minimum_order?
      original_price >= coupon.minimum_order
    end

    # if the coupon is unique it shouldn't have been used already
    def valid_coupon?
      (coupon.unique == false || available?) && (coupon.expired_at == nil || coupon.expired_at > Time.now)
    end

    def available?
      if coupon.last_used_at || expired_or_not_used_by_same_user?
        false
      else
        remove_from_old_order if coupon.unique
        true
      end
    end

    def expired_or_not_used_by_same_user?
      if expired?
        if same_user?
          remove_from_old_order
          return false
        else
          return true
        end
      end

      false
    end

    def expired?
      coupon.last_applied_at && ((Time.now - coupon.last_applied_at) / 1.hours).hours < EXPIRE_APPLY_TIME
    end

    def same_user?
      identity_solver.user.id == coupon.orders.first.user.id
    end

    # Removes the coupon from the last order that applied it
    def remove_from_old_order
      coupon.orders&.first&.update(
        coupon_discount:   0,
        coupon_applied_at: nil,
        coupon_id:         nil
      )
    end

    # we calculate the discount depending on EUR or PERCENT
    def coupon_discount
      if coupon.unit == :value
        coupon.discount
      elsif coupon.unit == :percent
        original_price * (coupon.discount / 100)
      else
        0
      end
    end
end
