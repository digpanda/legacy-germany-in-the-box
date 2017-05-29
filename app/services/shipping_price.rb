 # small library to guess the shipping prices via calculations
class ShippingPrice

  DISCOUNT_PERCENT = 30.freeze
  FALLBACK_PARTNER = :mkpost.freeze
  FALLBACK_SHIPPING_RATE_TYPE = :general.freeze
  FALLBACK_SHIPPING_RATE = 0.freeze

  attr_reader :order

  def initialize(order)
    @order = order
  end

  def price
    (shipping_rate.price) * approximation_change
  end

  # we sum the weight of all the order items
  def weight
    order.order_items.reduce(0) do |acc, order_item|
      acc + order_item.weight
    end
  end

  # if the system evolves, the shipping rate type should be selected
  # via a priority list. for now there is only one so it doesn't matter.
  # NOTE : i didn't code it yet because of the high risk there's no shipping rate found
  # depending the result
  def type
    order.order_items.first&.products&.first&.shipping_rate_type || FALLBACK_SHIPPING_RATE_TYPE
  end

  def approximation_change
    ((100 - DISCOUNT_PERCENT).to_f / 100)
  end

  def shipping_rate
    binding.pry
    @shipping_rate ||= ShippingRate.where(:weight.gte => weight).where(:type => type).where(partner: logistic_partner).order_by(weight: :asc).first || FALLBACK_SHIPPING_RATE
  end

  def logistic_partner
    if [:manual, :borderguru].include? Setting.instance.logistic_partner
      FALLBACK_PARTNER # this will set a default rate for the partners without ShippingRate defined
    else
      Setting.instance.logistic_partner
    end
  end

end
