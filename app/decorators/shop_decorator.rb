class ShopDecorator < Draper::Decorator

  include Imageable

  delegate_all
  decorates :shop

  private

  def thumb_params(img_field)
    if img_field == :logo
      Rails.configuration.logo_image_thumbnail
    elsif img_field == :banner
      Rails.configuration.banner_image_thumbnail
    else
      Rails.configuration.product_image_thumbnail
    end
  end

  def detail_params(img_field)
    if img_field == :logo
      Rails.configuration.logo_image_detailview
    elsif img_field == :banner
      Rails.configuration.banner_image_detailview
    else
      Rails.configuration.product_image_detailview
    end
  end
end

