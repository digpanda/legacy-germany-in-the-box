module SkuPricing
  extend ActiveSupport::Concern

  attr_reader :bypass_locked

  included do
    field :price, type: Float, default: 0
    field :reseller_price, type: Float, default: 0

    validates :price, presence: true, numericality: { greater_than: 0 }
    validates :reseller_price, presence: true, numericality: { greater_than: 0 }
  end

  # TODO : at some point we should switch
  # `price` to `casual_price` totally but for now
  # it's safer to keep both of them
  def casual_price
    price
  end

  def price_origin
    Thread.current[:price_origin] || :casual_price
  end

  # price per unit depends on
  # the context of the user
  def price_per_unit
    case price_origin
    when :reseller_price
      reseller_price
    when :casual_price
      price
    else
      price
    end
  end

end
