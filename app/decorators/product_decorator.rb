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

  def short_desc(characters = 50)
    truncate(self.desc, length: characters)
  end

  # complete cleaning for CSV file
  def clean_desc(characters = 240)
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
end
