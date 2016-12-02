class OrderItemSkuIdToEmbeddedProduct < Mongoid::Migration
  def self.up
    # we need to convert the product and incorporate it
    # as embedded document
    # OrderItem.all.each do |order_item|
    #   if order_item.product_id
    #     binding.pry
    #     original_product = Product.find(order_item.product_id)
    #     new_product = original_product.clone
    #     order_item.product = new_product
    #     order_item.save
    #   end
    # end
  end

  def self.down
  end
end
