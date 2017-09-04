class TrackingIdToOrderTracking < Mongoid::Migration
  def self.up
    puts "We will check all orders ..."
    Order.all.each do |order|
      old_tracking_id = order.attributes['tracking_id']
      order_tracking = OrderTracking.create!(
        order: order,
        unique_id: old_tracking_id
      )
      puts "OrderTraking #{order_tracking.id} created from `tracking_id`.`#{old_tracking_id}`"
    end
    puts "End of process."
  end

  def self.down
  end
end
