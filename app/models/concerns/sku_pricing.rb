module SkuPricing
  extend ActiveSupport::Concern

  attr_reader :bypass_locked

  included do
    field :price, type: Float, default: 0
    field :reseller_price, type: Float, default: 0

    validates :price, presence: true, numericality: { greater_than: 0 }
    validates :reseller_price, presence: true, numericality: { greater_than: 0 }
  end

  def price_origin
    # TODO : remove the `tester?` after a little while
    if Thread.current[:tester?]
      Thread.current[:custom_price]
    else
      :casual_price
    end
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
