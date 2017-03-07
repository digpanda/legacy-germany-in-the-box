 # small library to guess the shipping prices via calculations
class ShippingPrice

  DISCOUNT_PERCENT = 30

  attr_reader :sku, :product

  def initialize(sku)
    @sku = sku.decorate
    @product = sku.product
  end

  def price
    (shipping_rate.price) * approximation_change
  end

  def approximation_change
    ((100 - DISCOUNT_PERCENT).to_f / 100)
  end

  def shipping_rate
    @shipping_rate ||= ShippingRate.where(:weight.gte => sku.weight).where(:type => product.shipping_rate_type).order_by(weight: :asc).first
  end

end
