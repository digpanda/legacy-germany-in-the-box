class DuplicateSkuImagesToNewModel < Mongoid::Migration
  def self.up
    # Copy old image system to new image system for skus in products
    Product.all.each do |product|
      product.skus.each do |sku|
        [:img0, :img1, :img2, :img3].each do |field|
          if sku.send(field) && !sku.send(field).url.empty?
            image = sku.images.new
            image.remote_file_url = sku.send("remote_#{field}_url")
            image.save
          end
        end
      end
    end

    # Copy old image system to new image system for skus in order items
    OrderItem.all.each do |order_item|
      sku = order_item.sku
      [:img0, :img1, :img2, :img3].each do |field|
        if sku.send(field) && !sku.send(field).url.empty?
          image = sku.images.new
          image.remote_file_url = sku.send("remote_#{field}_url")
          image.save
        end
      end
    end
  end

  def self.down
  end
end
