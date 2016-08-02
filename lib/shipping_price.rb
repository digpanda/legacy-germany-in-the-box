 #  small library to guess the shipping prices via calculations
class ShippingPrice

  VOLUMETRIC_DIVIDOR = 5000.00

  FIRST_KILO_PRICE = 8.8
  PRICE_PER_KILO = 2.2

  APPROXIMATION_PERCENT = 15.00 # %

  # add `to_b` functionality to floats
  Float.include CoreExtensions::Float::BigDecimalConverter

  attr_reader :order

  def initialize(order)
    @order = order.decorate
  end

  def price
    (FIRST_KILO_PRICE.to_b + other_kilos * PRICE_PER_KILO.to_b).to_f
  end

  private

  def other_kilos
    if rounded_volumetric_weight >= 1
      rounded_volumetric_weight - 1
    else
      0
    end
  end

  def products_volumetric_weight
    @volumetric_weight ||= order.total_volume.to_b / VOLUMETRIC_DIVIDOR.to_b
  end

  def rounded_volumetric_weight
    @rounded_volumetric_weight ||= (products_volumetric_weight * approximation).ceil
  end

  def approximation
    1 + (APPROXIMATION_PERCENT.to_b / 100)
  end

end