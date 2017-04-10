module ReferrersHelper
  # def get_referrer_provision(referrer)
  #   referrer.referrer_coupons.inject(0) do |provision, coupon|
  #     provision += coupon_orders_provision(coupon)
  #   end
  # end
  #
  # def coupon_orders_provision(coupon)
  #   coupon.orders.bought.inject(0) do |sum, order|
  #     sum += order.end_price * order.referrer_rate / 100
  #   end
  # end
end
