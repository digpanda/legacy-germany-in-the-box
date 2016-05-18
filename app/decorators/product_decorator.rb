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

  def get_sku(option_ids)
    skus.detect {|s| s.option_ids.to_set == option_ids.to_set}
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
end