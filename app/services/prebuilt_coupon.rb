class PrebuiltCoupon < BaseService
  class << self

    # this is the coupon given to each referrer when they are registered
    # NOTE : the protection here is important, please do not remove it
    # unless you know what you are doing.
    def referrer_coupon(referrer)
      unless referrer.has_coupon?
        Coupon.create(
          code: Coupon.available_code,
          unit: :percent,
          discount: Setting.instance.default_coupon_discount,
          minimum_order: 0,
          unique: false,
          desc: 'Referrer Coupon',
          origin: :make_referrer,
          group: :referrers,
          referrer: referrer,
        )
      end
    end

  end
end
