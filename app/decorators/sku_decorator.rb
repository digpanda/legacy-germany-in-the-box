class SkuDecorator < Draper::Decorator

  include Imageable
  include ActionView::Helpers::TextHelper # load some important helpers

  delegate_all
  decorates :sku

  def max_added_to_cart
    [Rails.configuration.max_add_to_cart_each_time, (self.unlimited ? Rails.configuration.max_add_to_cart_each_time : self.quantity)].min
  end

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
     self.quantity == 0
  end

  def more_description?
    self.attach0.file || self.data?
  end

  def data?
    !self.data.nil? || self.data.trim.empty?
  end

  def price_with_currency_yuan
    Currency.new(price).to_yuan.display
  end

  def price_in_yuan
    Currency.new(price).to_yuan.amount
  end

  def price_with_currency_euro
    Currency.new(price).display
  end

  def price_before_discount_in_yuan
    Currency.new(before_discount_price).to_yuan.display
  end

  def price_before_discount_in_euro
    Currency.new(before_discount_price).display
  end

  def before_discount_price
    price * 100 / (100 - discount)
  end

  def discount_with_percent
    "-%.2f %" % discount
  end

  def get_options_txt
    variants = self.option_ids.map do |oid|
      self.product.options.detect do |v|
        v.suboptions.where(id: oid).first
      end
    end

    variants.each_with_index.map do |v, i|
      o = v.suboptions.find(self.option_ids[i])
      o.name
    end.join(', ')
  end

end
