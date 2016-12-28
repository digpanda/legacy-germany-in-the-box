class PackageSkus
  include MongoidBase

  belongs_to :product

  field :sku_id
  field :quantity

  def sku
    @sku ||= product.skus.find(sku_id)
  end

end
