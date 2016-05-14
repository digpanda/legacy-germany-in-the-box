class SkuDecorator < Draper::Decorator

  include Imageable

  delegate_all
  decorates :sku

  def all_nonempty_img_fields
    @img_fields ||= self.attributes.keys.grep(/^img\d/).map(&:to_sym).select { |f| f if sku.read_attribute(f) }
  end

  def first_nonempty_img_url(version)
    f = self.attributes.keys.grep(/^img\d/).map(&:to_sym).detect { |f| f if sku.read_attribute(f) }
    image_url(f, version)
  end

  def raw_images_urls
    all_nonempty_img_fields.map { |f| self.send(f).url }
  end

  def price_with_currency
    "#{self.price} #{self.product.shop.currency.code}"
  end
  
  private

  def thumb_params(image_field)
    Rails.configuration.product_image_thumbnail
  end

  def detail_params(image_field)
    Rails.configuration.product_image_detailview
  end
  
end