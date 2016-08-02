# small library to guess the shipping prices via calculations
class ShippingPrice

  SMALL_CARTON_HEIGHT = 9.5
  SMALL_CARTON_WIDTH = 16.5
  SMALL_CARTON_LENGTH = 24

  BIG_CARTON_HEIGHT = 13.5
  BIG_CARTON_WIDTH = 20.7
  BIG_CARTON_LENGTH = 29.4

  VOLUMETRIC_DIVIDOR = 5000

  FIRST_KILO_PRICE = 8.8
  PRICE_PER_KILO = 2.2

  APPROXIMATION_PERCENT = 15 # %

  attr_reader :order

  #
  # REDO IT
  # Simplify to just use .ceil and total_volume of the order
  # first kilo is 8.8 then you add 2.2 per kilo (add 15% on product total volum before)
  #

  def initialize(order)
    @order = order.decorate
  end

  def price
    if total_cartons_estimated_volumetric_weight <= 1
      FIRST_KILO_PRICE
    else
      kilos_calculations.to_f
    end
  end

  private

  def kilos_calculations
    # we use BigDecimal because float is fucked up
    binding.pry
    (BigDecimal(FIRST_KILO_PRICE.to_s) + BigDecimal(PRICE_PER_KILO.to_s) * BigDecimal((total_cartons_estimated_volumetric_weight - 1).to_s))
  end

  def total_cartons_estimated_volumetric_weight
    @total_cartons_volumetric_weight ||=  begin
      small_cartons, big_cartons = 0, 0
      small_cartons = cartons[:small] if cartons[:small]
      big_cartons = cartons[:big] if cartons[:big]
      small_carton_volumetric_weight.ceil * small_cartons + big_carton_volumetric_weight.ceil * big_cartons
    end
  end

  def cartons
    if small_cartons_needed > 1
      {:big => big_cartons_needed}
    else
      {:small => small_cartons_needed}
    end
  end

  def small_cartons_needed
    (products_volumetric_weight * approximation / small_carton_volumetric_weight).ceil
  end

  def big_cartons_needed
    (products_volumetric_weight * approximation / big_carton_volumetric_weight).ceil
  end

  def approximation
    1 + (APPROXIMATION_PERCENT / 100)
  end

  def products_volumetric_weight
    @volumetric_weight ||= order.total_volume / VOLUMETRIC_DIVIDOR
  end

  def small_carton_volumetric_weight
    @small_carton_volumetric_weight ||= SMALL_CARTON_LENGTH * SMALL_CARTON_WIDTH * SMALL_CARTON_HEIGHT / VOLUMETRIC_DIVIDOR
  end

  def big_carton_volumetric_weight
    @big_carton_volumetric_weight ||= BIG_CARTON_LENGTH * BIG_CARTON_WIDTH * BIG_CARTON_HEIGHT / VOLUMETRIC_DIVIDOR
  end

end

def Float
  def to_bd
    BigDecimal(self)
  end
end