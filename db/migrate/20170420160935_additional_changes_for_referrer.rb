class AdditionalChangesForReferrer < Mongoid::Migration
  def self.up
    ReferrerProvision.all.each do |provision|
      user = User.where(id: provision.referrer_id).first
      if user
        puts "Changing id ReferrerProvision `referrer_id`."
        provision.referrer = user.referrer
        provision.save
      end
    end
    Coupon.all.each do |coupon|
      user = User.where(id: coupon.referrer_id).first
      if user
        puts "Changing id Coupon `referrer_id`."
        coupon.referrer = user.referrer
        coupon.save
      end
    end
  end

  def self.down
  end
end
