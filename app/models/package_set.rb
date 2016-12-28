class PackageSet
  include MongoidBase

  field :name
  field :price

  belongs_to :shop, inverse_of: :package_sets
  embeds_many :package_skus, inverse_of: :package_set, cascade_callbacks: true

end
