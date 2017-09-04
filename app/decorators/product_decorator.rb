class ProductDecorator < Draper::Decorator

  include ActionView::Helpers::TextHelper # load some important helpers

  delegate_all
  decorates :product

  def product_cover_url
    skus.each do |sku|
      image = sku.images&.first&.thumb
      return image if image
    end
    nil
  end

  def featured_sku_img_url(img_field, version)
    return nil unless sku = featured_sku

    first_sku_image
  end

  def format_desc
     simple_format(self.desc)
  end

  def short_desc(characters=50)
    truncate(self.desc, :length => characters)
  end

  # complete cleaning for CSV file
  def clean_desc(characters=240)
    Cleaner.slug(self.desc, characters)
  end

  def first_sku_image
    product_cover_url || 'no_image_available.png'
  end

  def best_discount
    if best_discount_sku
      best_discount_sku.decorate.discount_with_percent
    end
  end

  def preview_discount
    self.featured_sku.decorate.discount_with_percent
  end

  def preview_price_yuan
    self.featured_sku.price_with_taxes.in_euro.to_yuan.display
  end

  def preview_fees_yuan_html
    self.featured_sku.taxes_per_unit.in_euro.to_yuan.display_html
  end

  def preview_price_yuan_html
    self.featured_sku.price_with_taxes.in_euro.to_yuan.display_html
  end

  def preview_price_euro
    self.featured_sku.price_with_taxes.in_euro.display
  end

  def preview_price_euro_html
    self.featured_sku.price_with_taxes.in_euro.display_html
  end

end
