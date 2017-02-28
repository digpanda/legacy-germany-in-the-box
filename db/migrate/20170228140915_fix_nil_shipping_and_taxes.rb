class FixNilShippingAndTaxes < Mongoid::Migration
  def self.up
    Order.not.bought.each {|order| order.order_items.each {|order_item| order_item.update(shipping_per_unit: nil, taxes_per_unit: nil)}}
  end

  def self.down
  end
end