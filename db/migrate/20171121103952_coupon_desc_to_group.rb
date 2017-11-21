class CouponDescToGroup < Mongoid::Migration
  def self.up
    # we expire all the old coupons linked to referrers
    Coupon.all.each do |coupon|
      if coupon.desc == 'Referrer Coupon'
        coupon.group = :referrers
        coupon.origin = :make_referrer
        puts "Coupon #{coupon.id} has now `referrers` assigned as group"
        if coupon.discount == 10.00
          coupon.expired_at = Time.now
          puts "Coupon was 10% and is now expired"
        end
        coupon.save(validate: false)
      end

      # now we try to generate again coupons for referrers
      # which are valid
      Referrer.all.each do |referrer|
        # this will generate 5% coupons for every referrer
        # and it will be considered `main_coupon`
        Coupon.create_referrer_coupon(referrer)
        puts "Coupon #{referrer.main_coupon.code} was created for Referrer #{referrer.id}"
      end
    end

  end

  def self.down
  end
end
