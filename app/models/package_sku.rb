class PackageSku
  include MongoidBase

  field :sku_id
  field :quantity

  belongs_to :product
  embedded_in :package_set

  validates_presence_of :sku_id
  validates_presence_of :quantity

  def sku
    @sku ||= product.skus.find(sku_id)
  end

end
