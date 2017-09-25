class SkuDecorator < Draper::Decorator
  include Concerns::Imageable
  include ActionView::Helpers::TextHelper # load some important helpers

  delegate_all
  decorates :sku

  def highlighted_image
    # binding.pry
    images.first&.image_url(:file, :cart)
    #images.first&.file&.url
    # raw_images_urls.first
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

  def price_with_currency_yuan
    price_with_taxes.in_euro.to_yuan.display
  end

  def price_with_currency_yuan_html
    price_with_taxes.in_euro.to_yuan.display_html
  end

  def price_in_yuan
    price_with_taxes.in_euro.to_yuan.amount
  end

  def price_with_currency_euro
    price.in_euro.display
  end

  def price_with_currency_euro_html
    price.in_euro.display_html
  end

  def price_before_discount_in_yuan
    before_discount_price.in_euro.to_yuan.display
  end

  def price_before_discount_in_yuan_html
    before_discount_price.in_euro.to_yuan.display_html
  end

  def price_before_discount_in_euro
    before_discount_price.in_euro.display
  end

  def price_before_discount_in_euro_html
    before_discount_price.in_euro.display_html
  end

  def before_discount_price
    price_with_taxes * 100 / (100 - discount)
  end

  def price_after_discount_in_yuan
    after_discount_price.in_euro.to_yuan.display
  end

  def price_after_discount_in_euro
    after_discount_price.in_euro.display
  end

  def price_after_discount_in_yuan_html
    after_discount_price.in_euro.to_yuan.display_html
  end

  def price_after_discount_in_euro_html
    after_discount_price.in_euro.display_html
  end

  def total_price_after_discount_in_euro(quantity)
    (after_discount_price * quantity).in_euro.display
  end

  def after_discount_price
    price_with_taxes * (100 - discount) / 100
  end

  def discount_with_percent
    '-%.0f%' % discount
  end
end
