class Tasks::Cron::RefreshTrackings
  attr_reader :orders

  def initialize
    @orders = Order.ongoing
  end

  def perform
    puts 'We will refresh the tracking status from the API ...'
    orders.map(&:order_tracking).compact.each do |order_tracking|
      TrackingHandler.new(order_tracking).refresh!
      puts "OrderTracking #{order_tracking.id} refreshed."
    end
    puts 'End of process.'
  end

  private

end
