class Brand
  include MongoidBase

  strip_attributes

  field :name, type: String, localize: true
  field :slug, type: String
  field :html_desc, type: String, localize: true
  field :position, type: Integer, default: 0

  has_many :products, inverse_of: :brand

  scope :with_package_sets, -> { where(:id.in => PackageSet.active.map(&:brands).flatten.map(&:_id)) }

end
