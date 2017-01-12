class SkuDecorator < Draper::Decorator

  include Imageable
  include ActionView::Helpers::TextHelper # load some important helpers

  delegate_all
  decorates :sku

  def max_added_to_cart
    [Rails.configuration.achat[:max_add_to_cart_each_time], (self.unlimited ? Rails.configuration.achat[:max_add_to_cart_each_time] : self.quantity)].min
  end

  def all_nonempty_img_fields
    @img_fields ||= self.attributes.keys.grep(/^img\d/).map(&:to_sym).select { |f| f if sku.read_attribute(f) }
  end

  def first_nonempty_img_url(version)
    f = self.attributes.keys.grep(/^img\d/).map(&:to_sym).detect { |f| f if sku.read_attribute(f) }
    unless f.nil?
      image_url(f, version)
    end
  end

  def raw_images_urls
    all_nonempty_img_fields.map { |f| self.send(f).url }
  end

  def discount?
    discount > 0
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
    !self.data.nil? || (self.data.is_a?(String) && !self.data.trim.empty?)
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

  def discount_with_percent
    "-%.0f%" % discount
  end

end
