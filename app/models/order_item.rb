class OrderItem
  include MongoidBase
  include Locked

  SKU_DELEGATE_EXCEPTION = [:quantity]
  MAX_DESCRIPTION_CHARACTERS = 200

  field :quantity, type: Integer,    default: 1
  field :taxes_per_unit, type: Float
  field :price_per_unit, type: Float
  field :referrer_rate, type: Float, default: 0.0

  # the price origin is put on the order item level for constitency purpose
  # each item of one order should have one unique price origin
  # but since the price is defined at the sku / package sku level
  # we better set on the order item as well.
  field :price_origin, type: Symbol, default: :casual_price # [:casual_price, :reseller_price]

  before_save :ensure_price_per_unit, :ensure_taxes_per_unit

  def ensure_price_per_unit
    unless price_per_unit
      self.price_per_unit = sku.price_per_unit
    end
  end

  def ensure_taxes_per_unit
    unless taxes_per_unit
      self.taxes_per_unit = sku.taxes_per_unit
    end
  end

  belongs_to :product
  belongs_to :order, counter_cache: true
  belongs_to :package_set

  # if we use the model somewhere else than the product
  # like in `order_item` we need to trace the original sku
  # this is essential to transmit informations and see clear
  # we use this data to avoid getting lost with the ids
  # NOTE : maybe make a small library to manage this kind of things in a DRY way
  belongs_to :sku_origin, class_name: 'Sku', foreign_key: :sku_origin_id
  def sku_origin
    product.skus.find(sku_origin_id)
  end

  embeds_one :sku

  validates :quantity,      presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :product,       presence: true
  validates :order,         presence: true

  scope :with_sku, -> (sku) { self.where(sku_origin_id: sku.id) }
  scope :without_package_set, -> { self.where(package_set: nil) }

  # right now we exclusively have delegated methods from the sku
  # if the method is missing we get it from the sku
  # directly when possible
  def method_missing(method, *params, &block)
    return if SKU_DELEGATE_EXCEPTION.include?(method)
    if sku.respond_to?(method)
      sku.send(method, *params, &block)
    end
  end

  def selected_options(locale = nil)
    product.options.map do |option|
      option.suboptions.map do |suboption|
        if option_ids.include? suboption.id.to_s
          if locale.nil?
            suboption.name
          else
            suboption.name_translations[locale]
          end
        end
      end
    end.flatten.compact
  end

  def refresh_referrer_rate!
    self.referrer_rate = ReferrerRateCalculator.new(self).solve
  end

  def clean_desc
    "#{product.clean_name} #{product.decorate.clean_desc(MAX_DESCRIPTION_CHARACTERS)}"
  end

  def total_price
    unless price_per_unit
      # TODO : to remove at some point -> to 10/10/2017 it has still issues.
      # it seems sometimes the price isn't saved correctly. this trick works so far.
      ensure_price_per_unit
      self.save(validate: false)
    end
    quantity * price_per_unit
  end

  def total_taxes
    quantity * taxes_per_unit
  end

  def total_price_with_taxes
    total_price + total_taxes
  end

  def price_with_taxes
    price_per_unit + taxes_per_unit
  end

  def volume
    sku.volume * quantity
  end
end
