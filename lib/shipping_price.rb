 #  small library to guess the shipping prices via calculations
 #  it takes the first prices into consideration and couple them with the < weight to match
 #  if it goes more than the last `special kilo price` segment, it simply use the casual price per kilo
class ShippingPrice

  VOLUMETRIC_DIVIDOR = 5000.00
  APPROXIMATION_PERCENT = 20.00 # %
  FIRST_PRICES = [5.19, 9.19, 10.49, 11.79]
  FIRST_PRICES_KILOS_SEGMENTS = [0.5, 1.0, 1.5, 2.0]
  PRICE_PER_KILO = 2.5
  VAT_PERCENT = 19.00 # %

  # add `to_b`, `ceil_tp` functionality to floats / fixnum
  Float.include CoreExtensions::Float::BigDecimalConverter
  Float.include CoreExtensions::Float::CeilTo
  Fixnum.include CoreExtensions::Fixnum::BigDecimalConverter

  attr_reader :order

  def initialize(order)
    @order = order.decorate
  end

  def price
    (price_without_vat * vat).to_f.round(2)
  end

  def below_two_kilos_price
    FIRST_PRICES_KILOS_SEGMENTS.each_with_index do |segment, index|
      if rounded_volumetric_weight < segment
        return FIRST_PRICES[index]
      end
    end
    return FIRST_PRICES.last
  end

  def price_without_vat
    (below_two_kilos_price.to_b + other_kilos * PRICE_PER_KILO.to_b)
  end

  private

  def other_kilos
    if rounded_volumetric_weight > FIRST_PRICES_KILOS_SEGMENTS.last
      rounded_volumetric_weight - FIRST_PRICES_KILOS_SEGMENTS.last
    else
      0.0
    end
  end

  def products_volumetric_weight
    @volumetric_weight ||= order.total_volume.to_b / VOLUMETRIC_DIVIDOR.to_b
  end

  def rounded_volumetric_weight
    @rounded_volumetric_weight ||= (products_volumetric_weight * approximation).to_f.ceil_to(1)
  end

  def vat
    1 + (VAT_PERCENT.to_b / 100)
  end

  def approximation
    1 + (APPROXIMATION_PERCENT.to_b / 100)
  end

end
