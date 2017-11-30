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

  # if the casual total price (the normal one) is different from the current price with taxes
  # it means the price has been altered and is different
  def custom_price?
    casual_total_price != price_with_taxes
  end

  # def total_price
  #   price_with_taxes * quantity
  # end

  def casual_total_price
    custom_price = Thread.current[:custom_price]
    Thread.current[:custom_price] = :casual_price
    final_price = price_with_taxes
    Thread.current[:custom_price] = custom_price
    final_price
  end

  # TODO : we should remove this since
  # the system has to be rethought entirely
  def after_discount_price
    price_with_taxes * (100 - discount) / 100
  end

  def discount_with_percent
    '-%.0f%' % discount
  end
end
