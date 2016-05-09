class SkuDecorator < Draper::Decorator

  delegate_all
  decorates :sku

  def all_nonempty_img_fields
    @img_fields ||= self.attributes.keys.grep(/^img\d/).map(&:to_sym).select { |f| f if sku.read_attribute(f) }
  end

  def raw_images_urls
    all_nonempty_img_fields.map { |f| self.send(f).url }
  end
end