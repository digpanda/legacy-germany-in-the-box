class ChangeCorruptedSku < Mongoid::Migration
  def self.up
    # we need to convert the sku_id and incorporate it
    # as embedded document
    OrderItem.all.each do |order_item|
      unless order_item.product.skus.where(id: order_item.sku_id).first
        puts "SkuId `#{order_item.sku_id}` seems unknown but we will try to proceed anyway ..."

        if order_item.sku_id.nil?
          puts "SkuId is nil, we forget about this entry."
          next
        end

        # let's try to find this through
        # all the products possible
        original_sku = begin
            Product.all.each do |product|
            if product.skus.where(id: order_item.sku_id).first
              product.skus.where(id: order_item.sku_id).first
            end
          end
        end

        # since we could not find the exact sku we replace it
        # by the first one from the product, this shouldn't alter the system too much.
        # and it's only a few orders.
        if original_sku.nil?
          original_sku = order_item.product.skus.first
          puts "Could not find original Sku. We select the first one from the Product."
        end

        # REPLICA OF PREVIOUS MIGRATION
        new_sku = original_sku.clone
        order_item.sku = new_sku
        order_item.sku_origin = original_sku
        # changes which could have been important through the time
        order_item.sku.weight = order_item.weight
        order_item.sku.price = order_item.price
        order_item.sku.option_ids = order_item.option_ids
        order_item.sku.save
        # end of change through the time
        order_item.save
        puts "Proceeded."

      end
    end
  end

  def self.down
  end
end
