class StockManager

  attr_reader :order

  def initialize(order)
    @order = order
  end

  def in_order!
    order.order_items.each do |order_item|
      # we take the original sku not the one from the order item
      sku = order_item.sku_origin
      sku.quantity -= order_item.quantity unless sku.unlimited
      sku.save!
    end
  end

end
