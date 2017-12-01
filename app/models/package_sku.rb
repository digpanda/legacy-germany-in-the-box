class PackageSku
  include MongoidBase

  field :sku_id
  field :quantity, type: Integer
  field :price, type: Float, default: 0
  field :reseller_price, type: Float, default: 0
  field :taxes_per_unit, type: Float, default: 0

  belongs_to :product
  embedded_in :package_set

  validates_presence_of :sku_id
  validates_presence_of :quantity

  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :reseller_price, presence: true, numericality: { greater_than: 0 }

  # price per unit depends on
  # the context of the user
  def price_per_unit
    case Thread.current[:custom_price]
    when :reseller_price
      reseller_price
    when :casual_price
      price
    else
      price
    end
  end

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
