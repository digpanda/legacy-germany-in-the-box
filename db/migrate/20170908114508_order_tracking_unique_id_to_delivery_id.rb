class OrderTrackingUniqueIdToDeliveryId < Mongoid::Migration
  def self.up
    OrderTracking.all.each do |order_tracking|
      old_unique_id = order_tracking.attributes['unique_id']
      puts "Changing Order Tracking #{order_tracking.id} -> #{old_unique_id}"
      order_tracking.delivery_id = old_unique_id
      order_tracking.save!(validate: false)
    end
  end

  def self.down
  end
end
