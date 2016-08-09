class ProductDecorator < Draper::Decorator

  include ActionView::Helpers::TextHelper # load truncate

  delegate_all
  decorates :product

  def buyable?
    active? && hs_code != nil && skus.count > 0 && shop.decorate.buyable?
  end

  def active?
    status == true && approved != nil
  end

  def sku_from_option_ids(option_ids)
    skus.detect {|s| s.option_ids.to_set == option_ids.to_set}
  end

  def product_cover_url
    if sku = skus.first
      first_nonempty = sku.decorate.all_nonempty_img_fields.first
      sku.decorate.image_url(first_nonempty, :thumb) if first_nonempty
    end
  end

  def get_mas
    @mas ||= skus.is_active.to_a.sort { |s1, s2| s1.unlimited ? 1 : s1.quantity <=> s2.quantity }.last
  end

  def get_mas_img_url(img_field, version)
    return nil unless mas = get_mas

    if mas.decorate.all_nonempty_img_fields.include?(img_field)
      mas.decorate.image_url(img_field, version)
    end
  end

  def has_option?
    self.options&.select { |o| o.suboptions&.size > 0 }.size > 0
  end

  def format_desc
     simple_format(self.desc)
  end

  def short_desc(characters=50)
    truncate(self.desc, :length => characters)
  end

  def clean_desc(characters=240)
    truncate(self.desc.squish.downcase, :length => characters).gsub(',', '')
  end

  def grouped_variants_options
    options.map { |v| [v.name, v.suboptions.sort { |a,b| a.name <=> b.name }.map { |o| [ o.name, o.id.to_s]}] }.to_a
  end

  def first_sku_image
    skus.first ? skus.first.decorate.first_nonempty_img_url(:thumb) : 'no_image_available.png' # to be refactored ?
  end

  def preview_discount
    self.get_mas.decorate.discount_with_percent
  end

  def preview_price_yuan
    self.get_mas.decorate.price_with_currency_yuan
  end

  def preview_price_euro
    self.get_mas.decorate.price_with_currency_euro
  end
end
