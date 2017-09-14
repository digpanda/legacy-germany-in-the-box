class OrderTrackingDeliveryProvidersPostelbeTypo < Mongoid::Migration
  def self.up
    OrderTracking.all.each do |tracking|
      unless tracking.delivery_provider.nil?
        puts "OrderTracking #{tracking.id} with provider `#{tracking.delivery_provider}` to be lower cased ..."
        tracking.delivery_provider = tracking.delivery_provider.downcase
        tracking.save(validate: false)
      end
    end
    puts "End of process."
  end

  def self.down
  end
end
