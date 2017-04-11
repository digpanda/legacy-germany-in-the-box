class SetCouponsToDontExcludeChina < Mongoid::Migration
  def self.up
    Coupon.all.each do |coupon|
      coupon.exclude_china = false
      coupon.save
    end
  end

  def self.down
  end
end