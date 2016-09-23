class ProductDecorator < Draper::Decorator

  include ActionView::Helpers::TextHelper # load some important helpers

  delegate_all
  decorates :product

  def product_cover_url
    if sku = skus.first
      first_nonempty = sku.decorate.all_nonempty_img_fields.first
      sku.decorate.image_url(first_nonempty, :thumb) if first_nonempty
    end
  end

  def featured_sku_img_url(img_field, version)
    return nil unless mas = featured_sku

    if mas.decorate.all_nonempty_img_fields.include?(img_field)
      mas.decorate.image_url(img_field, version)
    end
  end

  def format_desc
     simple_format(self.desc)
  end

  def short_desc(characters=50)
    truncate(self.desc, :length => characters)
  end

  def clean_desc(characters=240)
    I18n.transliterate(truncate(self.desc.squish.downcase, :length => characters).gsub(',', ''))
  end

  def first_sku_image
    skus.first ? skus.first.decorate.first_nonempty_img_url(:thumb) : 'no_image_available.png' # to be refactored ?
  end

  def preview_discount
    self.featured_sku.decorate.discount_with_percent
  end

  def preview_price_yuan
    self.featured_sku.decorate.price_with_currency_yuan
  end

  def preview_price_yuan_html
    self.featured_sku.decorate.price_with_currency_yuan_html
  end

  def preview_price_euro
    self.featured_sku.decorate.price_with_currency_euro
  end

  def preview_price_euro_html
    self.featured_sku.decorate.price_with_currency_euro_html
  end

end
