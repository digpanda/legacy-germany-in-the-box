class ConvertingAllMatchingOrdersToTerminated < Mongoid::Migration
  def self.up
    Order.all.each do |order|
      if order.status == :paid || order.status == :shipped
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
