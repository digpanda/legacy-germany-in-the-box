class OrderItemNamingChanges < Mongoid::Migration
  def self.up
    OrderItem.all.each do |order_item|
      order_item.taxes_per_unit = order_item.manual_taxes
      order_item.shipping_per_unit = order_item.manual_shipping_cost
    end
  end

  def self.down
  end
end
