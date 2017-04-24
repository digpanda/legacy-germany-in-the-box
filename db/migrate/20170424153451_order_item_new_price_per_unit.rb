class OrderItemNewPricePerUnit < Mongoid::Migration
  def self.up

    OrderItem.all.each do |order_item|
      order_item.order.bypass_locked! # make sure it will systematically work
      order_item.price_per_unit = order_item.sku.price_per_unit || 0.0
      puts "Order Item Price Per Unit `#{order_item.price_per_unit}`"
      order_item.save
      puts "Saved : #{order_item.save}"
    end

  end

  def self.down
  end
end
