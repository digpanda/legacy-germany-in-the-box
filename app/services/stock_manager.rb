class StockManager

  attr_reader :order

  def initialize(order)
    @order = order
  end

  # reduce the sku quantity from the order
  # there's a protection so you can call
  # this exact action only once within the system
  def in_order!
    order.order_items.each do |order_item|
      # we take the original sku not the one from the order item
      sku = order_item.sku_origin
      unless sku.unlimited
        unless already_reduced?(order_item)
          StockHistory.create(order_item: order_item)
          sku.quantity -= order_item.quantity
          sku.quantity = 0 if sku.quantity < 0
        end
      end
      sku.save!

      if sku.quantity < Rails.configuration.gitb[:warning_sku_quantity]
        shopkeeper = order_item&.product&.shop&.shopkeeper
        Notifier::Shopkeeper.new(shopkeeper).sku_quantity_is_low(order_item, sku)
      end
    end
  end

  # exact opposite of in_order!
  # will manage to grow the sku quantity once
  # if it already happened, it won't do it again
  def out_order!
    order.order_items.each do |order_item|
      sku = order_item.sku_origin
      unless sku.unlimited
        if already_reduced?(order_item)
          StockHistory.where(order_item: order_item).first.delete
          sku.quantity += order_item.quantity
        end
      end
      sku.save!
    end
  end

  private

  def already_reduced?(order_item)
    StockHistory.where(order_item: order_item).count > 0
  end

end
