class ShippingPerUnitOrderBased < Mongoid::Migration

  # we actually just base the old orders shipping cost on the same logic than it was before
  # there should be absolutely no visible change in the pricing.
  def self.up
    Order.all.each do |order|
      puts "Processing Order `#{order.id}` ..."
      order.shipping_cost = order.order_items.reduce(0) do |acc, order_item|
        if order_item.shipping_per_unit
          acc + (order_item.shipping_per_unit * order_item.quantity)
        end
      end
      puts "New shipping cost is `#{order.shipping_cost}`"
      order.save(validation: false)
    end
  end

  def self.down
  end
end
