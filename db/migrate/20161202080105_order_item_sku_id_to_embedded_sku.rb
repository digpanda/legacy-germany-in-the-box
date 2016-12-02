class OrderItemSkuIdToEmbeddedSku < Mongoid::Migration
  def self.up
    # we need to convert the sku_id and incorporate it
    # as embedded document
    OrderItem.all.each do |order_item|
      original_sku = order_item.product.skus.find(order_item.sku_id)
      new_sku = original_sku.clone
      order_item.sku = new_sku
      order_item.save
    end
  end

  def self.down
  end
end
