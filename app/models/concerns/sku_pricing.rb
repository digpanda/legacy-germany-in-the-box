module SkuPricing
  extend ActiveSupport::Concern

  attr_reader :bypass_locked

  included do
    field :casual_price, type: Float, default: 0

    field :default_reseller_price, type: Float, default: 0
    field :junior_reseller_price, type: Float, default: 0
    field :senior_reseller_price, type: Float, default: 0

    validates :price, presence: true, numericality: { greater_than: 0 }
    validates :default_reseller_price, presence: true, numericality: { greater_than: 0 }
    validates :junior_reseller_price, presence: true, numericality: { greater_than: 0 }
    validates :senior_reseller_price, presence: true, numericality: { greater_than: 0 }
  end

  def price_origin
    Thread.current[:price_origin] || :casual_price
  end

  # price per unit depends on
  # the context of the user
  def price_per_unit
    case price_origin
    when :default_reseller_price
      default_reseller_price
    when :junior_reseller_price
      junior_reseller_price
    when :senior_reseller_price
      senior_reseller_price
    when :casual_price
      casual_price
    else
      casual_price
    end
  end

end
