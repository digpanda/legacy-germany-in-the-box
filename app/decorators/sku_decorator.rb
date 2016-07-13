class SkuDecorator < Draper::Decorator

  include Imageable

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
    self.discount > 0
  end

  def price_with_currency_yuan
    "%.2f #{Settings.instance.platform_currency.symbol}" % (self.price_in_yuan)
  end

  def price_in_yuan
    self.price * Settings.instance.exchange_rate_to_yuan
  end

  def price_with_currency_euro
    "%.2f #{Settings.instance.supplier_currency.symbol}" % self.price
  end

  def price_before_discount_in_yuan
    "%.2f #{Settings.instance.platform_currency.symbol}" % (self.price_in_yuan * 100 / discount_calculation)
  end

  def price_before_discount_in_euro
    "%.2f #{Settings.instance.supplier_currency.symbol}" % (self.price * 100 / discount_calculation)
  end

  def discount_with_percent
    "-%.2f %" % (self.discount)
  end

  def discount_calculation
    100-self.discount
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

  private

  def thumb_params(image_field)
    Rails.configuration.product_image_thumbnail
  end

  def detail_params(image_field)
    Rails.configuration.product_image_detailview
  end
  
  def fullsize_params(image_field)
    Rails.configuration.product_image_fullsize
  end

  def zoomin_params(image_field)
    Rails.configuration.product_image_zoomin
  end
end