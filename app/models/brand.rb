class Brand
  include MongoidBase
  include Mongoid::Slug

  strip_attributes

  field :name, type: String, localize: true
  slug :name

  field :html_desc, type: String, localize: true
  field :position, type: Integer, default: 0
  field :used_as_filter, type: Boolean, default: true

  has_many :products, inverse_of: :brand

  scope :with_package_sets, -> { where(:id.in => package_set_brand_ids) }
  scope :used_as_filters, -> { where(:used_as_filter.ne => false) }

  private

    def self.package_set_brand_ids
      PackageSet.active.map(&:brands).flatten.map(&:id)
    end
end
