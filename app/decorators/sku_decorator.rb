class SkuDecorator < Draper::Decorator

  include Imageable

  delegate_all
  decorates :sku

  def all_nonempty_img_fields
    @img_fields ||= self.attributes.keys.grep(/^img\d/).map(&:to_sym).select { |f| f if sku.read_attribute(f) }
  end

  def raw_images_urls
    all_nonempty_img_fields.map { |f| self.send(f).url }
  end

  private

  def thumb_params
    Rails.configuration.product_image_thumbnail
  end

  def detail_params
    Rails.configuration.product_image_detailview
  end

end