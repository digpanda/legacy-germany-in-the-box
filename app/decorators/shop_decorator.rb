class ShopDecorator < Draper::Decorator

  include Imageable

  delegate_all
  decorates :shop

  def more_billing_address?
   self.addresses.is_billing.size < Rails.configuration.max_num_shop_billing_addresses
  end

  def more_sender_address?
    self.addresses.is_sender.size < Rails.configuration.max_num_shop_sender_addresses
  end

  def more_both_address?
    self.shop.addresses.is_any.size < Rails.configuration.max_num_shop_billing_addresses
  end

  def can_change_to_billing?
    self.shop.addresses.size == 1 || self.shop.addresses.is_only_billing.size < Rails.configuration.max_num_shop_billing_addresses
  end

  def can_change_to_sender?
    self.shop.addresses.size == 1 || self.shop.addresses.is_only_sender.size < Rails.configuration.max_num_shop_sender_addresses
  end

  def can_change_to_both?
    self.shop.addresses.size == 1 || self.shop.addresses.is_only_both.size < [Rails.configuration.max_num_shop_billing_addresses, Rails.configuration.max_num_shop_sender_addresses].min && (self.shop.addresses.is_only_billing.size < Rails.configuration.max_num_shop_billing_addresses || self.shop.addresses.is_only_sender.size < Rails.configuration.max_num_shop_sender_addresses)
  end

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

