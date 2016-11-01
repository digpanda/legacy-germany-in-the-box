class RemoveCorruptedOrderItems < Mongoid::Migration
  def self.up
    # at some point some order_items did not have valid product
    # because the product attached to it was previously removed
    # the protection was made.
    # the following script clean the corrupted order_items
    OrderItem.all.each do |order_item|
      if order_item.product.nil?
        order_item.delete
      end
    end
  end

  def self.down
  end
end
