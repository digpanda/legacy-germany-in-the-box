class PriceOriginToDefaultResellerPrice < Mongoid::Migration
  def self.up
    OrderItem.all.each do |order_item|
      if order_item.price_origin == :reseller_price
        puts "OrderItem #{order_item.id} price_origin from `reseller_price` to `default_reseller_price`"
        order_item.price_origin = :default_reseller_price
        order_item.save(validate: false)
      end
    end
  end

  def self.down
  end
end
