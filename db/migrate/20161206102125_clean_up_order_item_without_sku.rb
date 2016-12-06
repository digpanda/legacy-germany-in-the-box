class CleanUpOrderItemWithoutSku < Mongoid::Migration
  def self.up
    Order.all.each do |order|
      unless order.bought?
        order.order_items.each do |order_item|
          if order_item.sku.nil?
            puts "Order_item `#{order_item.id}` deleted."
            order_item.delete
          end
        end
      end
    end
  end

  def self.down
  end
end
