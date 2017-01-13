class ShopDecorator < Draper::Decorator

  include Imageable
  include ActionView::Helpers::TextHelper # load truncate

  delegate_all
  decorates :shop

  def readable_wirecard_status
    case self.wirecard_status
    when :unactive
      "Not applied"
    when :active
      "Active"
    when :processing
      "Processing"
    when :documents_complete
      "Documents complete"
    when :declined
      "Disapproved"
    when :terminated
      "Terminated"
    else
      "Unknown"
    end
  end

  def can_buy?
    active? && bg_merchant_id != nil && addresses.is_shipping.count > 0
  end

  def active?
    status == true && approved != nil
  end

  def philosophy?
    self.philosophy && self.philosophy.strip.present?
  end

  def uniqueness?
    self.uniqueness && self.uniqueness.strip.present?
  end

  def stories?
    self.stories && self.stories.strip.present?
  end

  def german_essence?
    self.german_essence && self.german_essence.strip.present?
  end

  def more_new_address?
    self.addresses.is_only_both.size < [Rails.configuration.achat[:max_num_shop_billing_addresses], Rails.configuration.achat[:max_num_shop_sender_addresses]].min && (self.addresses.is_only_billing.size < Rails.configuration.achat[:max_num_shop_billing_addresses] || self.addresses.is_only_shipping.size < Rails.configuration.achat[:max_num_shop_sender_addresses])
  end

  def more_billing_address?
   self.addresses.is_billing.size < Rails.configuration.achat[:max_num_shop_billing_addresses]
  end

  def more_sender_address?
    self.addresses.is_shipping.size < Rails.configuration.achat[:max_num_shop_sender_addresses]
  end

  def more_both_address?
    self.shop.addresses.is_any.size < Rails.configuration.achat[:max_num_shop_billing_addresses]
  end

  def can_change_to_billing?
    self.shop.addresses.size == 1 || self.shop.addresses.is_only_billing.size < Rails.configuration.achat[:max_num_shop_billing_addresses]
  end

  def can_change_to_sender?
    self.shop.addresses.size == 1 || self.shop.addresses.is_only_shipping.size < Rails.configuration.achat[:max_num_shop_sender_addresses]
  end

  def can_change_to_both?
    self.shop.addresses.size == 1 || self.shop.addresses.is_only_both.size < [Rails.configuration.achat[:max_num_shop_billing_addresses], Rails.configuration.achat[:max_num_shop_sender_addresses]].min && (self.shop.addresses.is_only_billing.size < Rails.configuration.achat[:max_num_shop_billing_addresses] || self.shop.addresses.is_only_shipping.size < Rails.configuration.achat[:max_num_shop_sender_addresses])
  end

  def short_desc(characters=70)
    truncate(self.desc, :length => characters)
  end

  def manager_full_name
    "#{fname} #{lname}"
  end

end
