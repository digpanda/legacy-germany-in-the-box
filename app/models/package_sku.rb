class PackageSku
  include MongoidBase

  field :sku_id
  field :quantity

  belongs_to :product
  embedded_in :package_set

  def sku
    @sku ||= product.skus.find(sku_id)
  end

end
