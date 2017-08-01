class OrderReferrerField < Mongoid::Migration
  def self.up
    Order.all.each do |order|
      puts "Process Order `#{order.id}` ..."
      if order.referrer
        puts "Referrer already present, passing ..."
      else
        if order.user&.parent_referrer
          order.referrer = order.user.parent_referrer
          order.referrer_origin = :user
          order.save(validation: false)
          puts "Order Referrer was changed to a user one (Referrer `#{order.user.parent_referrer}`)."
        elsif order.coupon&.referrer
          order.referrer = order.coupon.referrer
          order.referrer_origin = :coupon
          order.save(validation: false)
          puts "Order Referrer was changed to a coupon one (Referrer `#{order.coupon.referrer}`)."
        end
      end
      puts "End of process for this order."
    end
  end

  def self.down
  end
end
