class ShippingPriceFix < Mongoid::Migration
  def self.up
    Order.bought.each do |order|
      puts 'Updating order...'
      puts 'setting shipping and taxes per unit price...'
      order.order_items.each do |order_item|
        order_item.update(shipping_per_unit: nil, taxes_per_unit: nil)
        order_item.ensure_taxes_per_unit
        order_item.ensure_shipping_per_unit
        order_item.save
      end

      order = Order.find(order.id)
      order_item = order.order_items.first

      puts 'updating shipping price of order items to match the total paid...'
      if order_item
        price_difference = ((order.total_price + order.extra_costs) - order.total_paid(:eur))
        total_shipping_price = order_item.shipping_per_unit * order_item.quantity
        new_diff = total_shipping_price - price_difference
        new_shipping_per_unit = new_diff / order_item.quantity
        order_item.update(shipping_per_unit: new_shipping_per_unit)

        if order.coupon
          puts 'updating price because of coupon'
          if order.coupon.unit == :value
            price_without_discount = order.total_paid(:eur) + order.coupon.discount
            price_diff = price_without_discount - order.total_paid(:eur)
            price_to_add = price_diff / order_item.quantity
            order_item.update(shipping_per_unit: (order_item.shipping_per_unit + price_to_add))
          elsif order.coupon.unit == :percent
            price_without_discount = order.total_paid(:eur) * 100 / (100 - order.coupon.discount)
            order.update(coupon_discount: price_without_discount * order.coupon.discount / 100)
            price_diff = price_without_discount - order.total_paid(:eur)
            price_to_add = price_diff / order_item.quantity
            order_item.update(shipping_per_unit: (order_item.shipping_per_unit + price_to_add))
          end
        end
      end
    end
  end

  def self.down
  end
end