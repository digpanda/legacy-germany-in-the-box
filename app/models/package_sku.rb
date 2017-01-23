class PackageSku
  include MongoidBase

  field :sku_id
  field :quantity, type: Integer
  field :price, type: Integer

  belongs_to :product
  embedded_in :package_set

  validates_presence_of :sku_id
  validates_presence_of :quantity
  validates_presence_of :price

  def sku
    @sku ||= product.skus.find(sku_id)
  end

  def total_price
    price * quantity
  end

end
