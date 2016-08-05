class ShopDecorator < Draper::Decorator

  include Imageable
  include ActionView::Helpers::TextHelper # load truncate

  delegate_all
  decorates :shop

  def philosophy?
    shop.philosophy && !shop.philosophy.empty?
  end

  def uniqueness?
    shop.uniqueness && !shop.uniqueness.empty?
  end

  def stories?
    shop.stories && !shop.stories.empty?
  end

  def german_essence?
    shop.german_essence && !shop.german_essence.empty?
  end
  
  def more_new_address?
    self.addresses.is_only_both.size < [Rails.configuration.max_num_shop_billing_addresses, Rails.configuration.max_num_shop_sender_addresses].min && (self.addresses.is_only_billing.size < Rails.configuration.max_num_shop_billing_addresses || self.addresses.is_only_sender.size < Rails.configuration.max_num_shop_sender_addresses)
  end
  
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

  def short_desc(characters=70)
    truncate(self.desc, :length => characters)
  end

  def manager_full_name
    "#{fname} #{lname}"
  end

end

