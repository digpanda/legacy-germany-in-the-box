class CopySkuFilesWorker
  include Sidekiq::Worker

  ATTACH_MAP = [:attach0]

  def perform(sku_product_id, target_id, sku_id, sku_clone_id, relationship)
    @product = Product.find(sku_product_id)
    @product_sku = @product.sku_with_id(sku_id)

    if relationship == 'plural'
      @target = Product.find(target_id)
      @target_sku = @target.sku_with_id(sku_clone_id)
    elsif relationship == 'singular'
      @target = OrderItem.find(target_id)
      @target_sku = @target.sku
    end

    copy_images_and_attachment
  end

  private

    def copy_images_and_attachment
      attach!
      copy_images!
    end

    def copy_images!
      @product_sku.images.each do |image|
        new_image = @target_sku.images.new
        CopyCarrierwaveFile::CopyFileService.new(image, new_image, :file).set_file
        new_image.save
      end
    end

    def attach!
      ATTACH_MAP.each do |attach_field|
        if @product_sku.send(attach_field).present?
          copy_file(attach_field)
        end
      end
    end

    def copy_file(field)
      if @product_sku.send(field).present?
        CopyCarrierwaveFile::CopyFileService.new(@product_sku, @target_sku, field).set_file
        @target_sku.save!
      end
    end
end
