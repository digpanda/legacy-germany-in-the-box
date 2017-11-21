class CouponDescToGroup < Mongoid::Migration
  def self.up
    # we expire all the old coupons linked to referrers
    Referrer.all.each do |referrer|

      if referrer.main_coupon
        coupon = referrer.main_coupon
        coupon.group = :referrers
        coupon.origin = :make_referrer
        puts "Coupon #{coupon.id} has now `referrers` assigned as group"
        coupon.expired_at = 1.days.ago
        puts "We auto-expire the current coupon"
        coupon.save(validate: false)
      end
      # this will generate 5% coupons for every referrer
      # and it will be considered `main_coupon`
      Coupon.create_referrer_coupon(referrer)
      puts "Coupon #{referrer.main_coupon.code} was created for Referrer #{referrer.id}"
    end

  end

  def self.down
  end
end
