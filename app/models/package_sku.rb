class PackageSku
  include MongoidBase

  belongs_to :product
  embedded_in :package_set

  field :sku_id
  field :quantity

  def sku
    @sku ||= product.skus.find(sku_id)
  end

end
