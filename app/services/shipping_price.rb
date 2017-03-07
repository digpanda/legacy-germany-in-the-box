 # small library to guess the shipping prices via calculations
 # it takes the first prices into consideration and couple them with the < weight to match
 # if it goes more than the last `special kilo price` segment
 # it simply use the casual price per kilo
class ShippingPrice

  VOLUMETRIC_DIVIDOR = 5000.00

  # add `to_b`, `ceil_to` functionality to floats / fixnum
  Float.include CoreExtensions::Float::BigDecimalConverter
  Float.include CoreExtensions::Float::CeilTo
  Fixnum.include CoreExtensions::Fixnum::BigDecimalConverter

  attr_reader :sku, :product

  def initialize(sku)
    @sku = sku.decorate
    @product = sku.product
  end

  def price
    shipping_rate.price #.to_f.round(2)
  end

  def shipping_rate
    @shipping_rate ||= ShippingRate.where(:weight.gte => sku.weight).where(:type => product.shipping_rate_type).order_by(weight: :asc).first
  end

  private

  def sku_volumetric_weight
    if sku.volume
      @volumetric_weight ||= sku.volume.to_b / VOLUMETRIC_DIVIDOR.to_b
    else
      0
    end
  end


end
