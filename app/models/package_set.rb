class PackageSet
  include MongoidBase

  field :name
  field :sku_ids

  belongs_to :shop, inverse_of: :package_sets

  def skus
    @skus ||= begin
      sku_ids.reduce([]) do |acc, sku_id|
        acc << Product.all.skus.find(sku_id)
      end
    end
  end

end
