class ConvertingAllMatchingOrdersToTerminated < Mongoid::Migration
  def self.up
    Order.all.each do |order|
      if order.status != :terminated && order.status != :cancelled
        puts "Order `#{order.id}` has the status `#{order.status}` will be converted."
        order.status = :terminated
        order.save(validate: false)
      end
    end
    puts "End of process."
  end

  def self.down
  end
end
