class CleanUpEmptyDestroyableOrders < Mongoid::Migration
  def self.up
    Order.all.each do |order|
      if order.order_items.count == 0
        puts "Processing Order `#{order.id}` ..."
        order.order_payments.where(status: :scheduled).delete_all
        puts "We removed the potential scheduled OrderPayments."
        if order.destroyable?
          puts "This order is destroyable."
          order.delete
          puts "Order destroyed."
        end
      end
    end
    puts "End of process."
  end

  def self.down
  end
end
