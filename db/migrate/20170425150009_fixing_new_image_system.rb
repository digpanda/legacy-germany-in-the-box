class FixingNewImageSystem < Mongoid::Migration
  # NOTE : no_timeout is here because there are so many entries
  # a cursor error would occur after a while.
  def self.up
    # Copy old image system to new image system for skus in products
    Product.no_timeout.all.each do |product|
      puts "Select Product `#{product.id}` ..."
      product.skus.no_timeout.each do |sku|
        puts "Select Sku `#{sku.id}` ..."
        sku.images.delete_all
        [:img0, :img1, :img2, :img3].each do |field|
          puts "Converting `#{field}` if it's not empty ..."
          if sku.send(field) && !sku.send(field).url.empty?
            puts "It's not empty. Processing ..."
            image = sku.images.new
            image.remote_file_url = sku.send(field).url
            image.save(validation: false)
            puts "Conversion was done."
          end
        end
      end
    end

    # Copy old image system to new image system for skus in order items
    OrderItem.no_timeout.all.each do |order_item|
      puts "Select OrderItem `#{order_item.id}` ..."
      sku = order_item.sku
      sku.images.delete_all
      puts "Select Sku `#{sku.id}` ..."
      [:img0, :img1, :img2, :img3].each do |field|
        puts "Converting `#{field}` if it's not empty ..."
        if sku.send(field) && !sku.send(field).url.empty?
          puts "It's not empty. Processing ..."
          image = sku.images.new
          image.remote_file_url = sku.send(field).url
          image.save(validation: false)
          puts "Conversion was done."
        end
      end
    end
  end

  def self.down
  end
end
