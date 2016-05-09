class ShopDecorator < Draper::Decorator

  include Imageable

  delegate_all
  decorates :shop

  private

  def thumb_params
    Rails.configuration.logo_image_thumbnail
  end

  def detail_params
    Rails.configuration.logo_image_detailview
  end
end

