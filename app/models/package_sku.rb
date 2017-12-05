class PackageSku
  include MongoidBase
  include SkuPricing

  field :sku_id
  field :quantity, type: Integer

  # NOTE : `price` and `reseller_price`
  # are contained in the SkuPricing concern

  field :taxes_per_unit, type: Float, default: 0

  belongs_to :product
  embedded_in :package_set

  validates_presence_of :sku_id
  validates_presence_of :quantity

  def sku
    @sku ||= product.skus.find(sku_id)
  end

  def total_price
    price_per_unit * quantity
  end

  def total_taxes
    taxes_per_unit * quantity
  end

  def total_price_with_taxes
    total_price + total_taxes
  end
end
