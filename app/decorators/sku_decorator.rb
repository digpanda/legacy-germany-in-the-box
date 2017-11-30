class SkuDecorator < Draper::Decorator
  include Concerns::Imageable
  include ActionView::Helpers::TextHelper # load some important helpers

  delegate_all
  decorates :sku

  def highlighted_image
    images.first&.image_url(:file, :cart)
  end

  def raw_images_urls
    valid_images.map { |field| self.send(field).url }
  end

  def format_data
    simple_format(self.data)
  end

  def quantity_warning?
    return false if self.unlimited || nothing_left? # no warning if unlimited or nothing left
    self.quantity <= ::Rails.application.config.digpanda[:products_warning]
  end

  def nothing_left?
    self.quantity == 0 && !self.unlimited
  end

  def more_description?
    self.attach0.file || self.data?
  end

  def data?
    !self.data.nil? && (self.data.is_a?(String) && !self.data.empty?)
  end

  def total_price
    price_with_taxes * quantity
  end

  def after_discount_price
    price_with_taxes * (100 - discount) / 100
  end

  def discount_with_percent
    '-%.0f%' % discount
  end
end
