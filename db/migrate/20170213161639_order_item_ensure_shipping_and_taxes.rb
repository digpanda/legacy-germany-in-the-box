class OrderItemEnsureShippingAndTaxes < Mongoid::Migration
  def self.up
    OrderItem.all.each do |order_item|
      order_item.ensure_taxes_per_unit
      order_item.ensure_shipping_per_unit
      order_item.save
    end
  end

  def self.down
  end
end
