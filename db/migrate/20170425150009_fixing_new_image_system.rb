class FixingNewImageSystem < Mongoid::Migration
  def self.up
    # Copy old image system to new image system for skus in products
    Product.all.each do |product|
      product.skus.each do |sku|
        sku.images.delete_all
        [:img0, :img1, :img2, :img3].each do |field|
          if sku.send(field) && !sku.send(field).url.empty?
            image = sku.images.new
            image.remote_file_url = sku.send(field).url
            image.save
          end
        end
      end
    end

    # Copy old image system to new image system for skus in order items
    OrderItem.all.each do |order_item|
      sku = order_item.sku
      sku.images.delete_all
      [:img0, :img1, :img2, :img3].each do |field|
        if sku.send(field) && !sku.send(field).url.empty?
          image = sku.images.new
          image.remote_file_url = sku.send(field).url
          image.save
        end
      end
    end
  end

  def self.down
  end
end