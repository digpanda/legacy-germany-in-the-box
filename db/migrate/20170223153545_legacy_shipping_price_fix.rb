class LegacyShippingPriceFix < Mongoid::Migration
  def self.up

    # Order.bought.each do |order|
    #
    #   puts "Let's check the order ..."
    #
    #   puts "Order TOTAL PAID : `#{order.total_paid(:eur)}`"
    #   puts "Order END PRICE : `#{order.end_price}`"
    #
    #   while order.total_paid(:eur) >= order.end_price
    #
    #     puts "We need to recalibrate ..."
    #
    #     order.order_items.each do |order_item|
    #
    #       unless order.total_paid(:eur) <= order.end_price
    #
    #         order_item.shipping_per_unit -= 0.01
    #         order_item.save
    #         order_item.reload
    #
    #         puts "New difference :"
    #         puts "Order TOTAL PAID : `#{order.total_paid(:eur)}`"
    #         puts "Order END PRICE : `#{order.end_price}`"
    #
    #       end
    #
    #     end
    #
    #   end
    #
    #   puts "---"
    #
    # end

  end

  def self.down
  end
end
