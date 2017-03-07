 # small library to guess the shipping prices via calculations
 # it takes the first prices into consideration and couple them with the < weight to match
 # if it goes more than the last `special kilo price` segment
 # it simply use the casual price per kilo
class ShippingPrice

  attr_reader :sku, :product

  def initialize(sku)
    @sku = sku.decorate
    @product = sku.product
  end

  def price
    shipping_rate.price
  end

  def shipping_rate
    @shipping_rate ||= ShippingRate.where(:weight.gte => sku.weight).where(:type => product.shipping_rate_type).order_by(weight: :asc).first
  end

end
