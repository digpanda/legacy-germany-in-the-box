class OrderItemNewPricePerUnit < Mongoid::Migration
  def self.up

    OrderItem.all.each do |order_item|
      order_item.ensure_price_per_unit
      puts "Order Item Price Per Unit `#{order_item.price_per_unit}` (#{order_item.id})"
      order_item.save(validation: false)
      # if order_item.order
      #   order_item.order.bypass_locked! # make sure it will systematically work
      # end
      puts "Saved : #{order_item.save}"
    end

  end

  def self.down
  end
end
