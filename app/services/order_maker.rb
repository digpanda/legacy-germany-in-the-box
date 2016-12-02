# cancel orders on the database and through APIs
class OrderMaker < BaseService

  attr_reader :order

  def initialize(order)
    @order = order
  end

  def add(sku, quantity)
    order.order_items.build.tap do |order_item|
      order_item.price = sku.price
      order_item.quantity = quantity
      order_item.weight = sku.weight
      order_item.product = sku.product
      order_item.product_name = sku.product.name
      order_item.sku = sku
      order_item.option_ids = sku.option_ids
      order_item.option_names = sku.get_options
    end.save!
    return_with(:success, order: order)
  end


end
