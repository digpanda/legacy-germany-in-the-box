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

  def short_desc(characters=60)
    truncate(self.desc, :length => characters)
    #self.desc.chars[0..characters].push("...").join
  end

  def clean_desc(characters=240)
    truncate(self.desc.squish.downcase, :length => characters)
  end

  def grouped_variants_options
    options.map { |v| [v.name, v.suboptions.sort { |a,b| a.name <=> b.name }.map { |o| [ o.name, o.id.to_s]}] }.to_a
  end

  def first_sku_image
    skus.first ? skus.first.decorate.first_nonempty_img_url(:thumb) : 'no_image_available.jpg'
  end

  def preview_price
    preview_sku = self.skus.where(:quantity.ne => 0).first
    if preview_sku.nil?
        preview_sku = self.skus.first
      if preview_sku.nil?
        preview_sku.decorate.price_with_currency
      else
        self.get_mas.decorate.price_with_currency
        #"0.00 #{Settings.instance.supplier_currency.symbol}"
      end
    else
      preview_sku.decorate.price_with_currency
    end
  end

  def preview_price_euro
    preview_sku = self.skus.where(:quantity.ne => 0).first
    if preview_sku.nil?
      preview_sku = self.skus.first
      if preview_sku.nil?
        preview_sku.decorate.price_with_currency_euro
      else
        self.get_mas.decorate.price_with_currency_euro
        #"0.00 #{Settings.instance.supplier_currency.symbol}"
      end
    else
      preview_sku.decorate.price_with_currency_euro
    end
  end
end