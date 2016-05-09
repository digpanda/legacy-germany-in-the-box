class ProductDecorator < Draper::Decorator

  delegate_all
  decorates :product

  def product_cover_url
    if sku = skus.first
      first_nonempty = sku.decorate.all_nonempty_img_fields.first
      if ENV['RAILS_ENV'] != 'local'
        sku.send(first_nonempty).url + Rails.configuration.image_thumbnail if first_nonempty
      else
        sku.send(first_nonempty).url(:thumb) if first_nonempty
      end
    end
  end

  def get_mas
    @mas ||= skus.is_active.to_a.sort { |s1, s2| s1.quantity <=> s2.quantity }.last
  end

  def get_mas_img_url(img_field)
    return nil unless mas = get_mas

    if mas.decorate.all_nonempty_img_fields.include?(img_field)
      if ENV['RAILS_ENV'] != 'local'
        mas.send(img_field).url + Rails.configuration.image_detailview
      else
        mas.send(img_field).url(:detail)
      end
    end
  end

  def has_option?
    self.options&.select { |o| o.suboptions && o.suboptions.size > 0 }.size > 0
  end

  def get_sku(option_ids)
    skus.detect {|s| s.option_ids.to_set == option_ids.to_set}
  end
end