 # small library to guess the shipping prices via calculations
class ShippingPrice

  FALLBACK_PARTNER = :mkpost.freeze
  FALLBACK_SHIPPING_RATE_TYPE = :general.freeze

  attr_reader :order

  def initialize(order)
    @order = order
  end

  # the price included the sku shipping cost which are
  # the casual order items cost and add the package sets
  # shipping cost if any
  def price
    sku_shipping_cost + package_set_shipping_cost
  end

  private

  # if there's any item we get a cost
  # otherwise it's logically set to 0.0
  # NOTE : this happens in case of package set only
  def sku_shipping_cost
    if sku_order_items.count > 0
      shipping_rate.price * calibration
    else
      0.0
    end
  end

  # we calculate the shipping cost by adding up all the package sets
  # shipping cost together and artificially calculating the quantity of each ones
  # NOTE : this operation costs a lot, we should find a smart way to reduce it
  def package_set_shipping_cost
    order.package_sets.reduce(0) do |acc, package_set|
      acc + (package_set.shipping_cost * order.package_set_quantity(package_set))
    end
  end

  def sku_order_items
    order.order_items.without_package_set
  end

  # we sum the weight of all the order items
  def weight
    sku_order_items.reduce(0) do |acc, order_item|
      acc + order_item.weight * order_item.quantity
    end
  end

  # if the system evolves, the shipping rate type should be selected
  # via a priority list. for now there is only one so it doesn't matter.
  # NOTE : i didn't code it yet because of the high risk there's no shipping rate found
  # depending the result
  def type
    sku_order_items.first&.products&.first&.shipping_rate_type || FALLBACK_SHIPPING_RATE_TYPE
  end

  # this is used to raise or reduce the end shipping cost
  # NOTE : it was set to 1 for now until we test and calibrate
  # WARNING : if you set it below 0, it can generate weird price numbers (think BigDecimal bullshit)
  def calibration
    1
  end

  def shipping_rate
    @shipping_rate ||= current_shipping_rate || ShippingRate.new(price: fallback_price)
  end

  # this is the fallback price
  # we take the highest shipping rate ratio
  # and use it together with the left weight
  # so it calculate the correct added price without limit
  def fallback_price
    (weight * fallback_ratio).round(2) # we round it to two decimals
  end

  # this is the ratio price on weight used to calculate the fallback price
  # it will help calculate prices if the weight isn't included in the shipping table
  def fallback_ratio
    highest_shipping_rate.price / highest_shipping_rate.weight
  end

  def highest_shipping_rate
    ShippingRate.where(partner: logistic_partner).where(type: type).order_by(weight: :desc).first
  end

  def current_shipping_rate
    ShippingRate.where(:weight.gte => weight).where(type: type).where(partner: logistic_partner).order_by(weight: :asc).first
  end

  def logistic_partner
    if Setting.instance.logistic_partner == :manual
      FALLBACK_PARTNER # this will set a default rate for the partners without ShippingRate defined
    else
      Setting.instance.logistic_partner
    end
  end

end
