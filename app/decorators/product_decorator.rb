class ProductDecorator < Draper::Decorator

  include ActionView::Helpers::TextHelper # load truncate

  delegate_all
  decorates :product

  def product_cover_url
    if sku = skus.first
      first_nonempty = sku.decorate.all_nonempty_img_fields.first
      sku.decorate.image_url(first_nonempty, :thumb) if first_nonempty
    end
  end

  def get_mas
    @mas ||= skus.is_active.to_a.sort { |s1, s2| s1.quantity <=> s2.quantity }.last
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

  def short_desc(characters=60)
    truncate(self.desc, :length => characters)
    #self.desc.chars[0..characters].push("...").join
  end

  def grouped_variants_options
    options.map { |v| [v.name, v.suboptions.sort { |a,b| a.name <=> b.name }.map { |o| [ o.name, o.id.to_s]}] }.to_a
  end

  def first_sku_image
    skus.first ? skus.first.decorate.first_nonempty_img_url(:thumb) : 'no_image_available.jpg'
  end

  def preview_price
    if self.skus.first.nil?
      "0.00 #{Settings.instance.platform_currency.symbol}"
    else
      self.skus.first.decorate.price_with_currency
    end
  end

  def preview_price_euro
    if self.skus.first.nil?
      "0.00 #{Settings.instance.supplier_currency.symbol}"
    else
      self.skus.first.decorate.price_with_currency_euro
    end
  end
end