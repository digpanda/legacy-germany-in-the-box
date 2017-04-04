class StockManager

  attr_reader :order

  def initialize(order)
    @order = order
  end

  def in_order!
    order.order_items.each do |order_item|
      # we take the original sku not the one from the order item
      sku = order_item.sku_origin
      unless sku.unlimited
        sku.quantity -= order_item.quantity
        sku.quantity = 0 if sku.quantity < 0
      end
      sku.save!

      if sku.quantity < Rails.configuration.gitb[:warning_sku_quantity]
        DispatchNotification.new.perform({
          user: order_item&.product&.shop&.shopkeeper,
          title: "Die Verfügbarkeit eines Produkts ist fast Null",
          desc: "Das Produkt '#{order_item.product&.name}' verfügt über #{sku.quantity} Verfügbarkeit."
        })
      end
    end
  end

end
