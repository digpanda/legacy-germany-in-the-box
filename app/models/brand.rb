class Brand
  include MongoidBase
  include Mongoid::Slug

  strip_attributes

  field :name, type: String, localize: true
  slug :name, history: true

  field :html_desc, type: String, localize: true
  field :position, type: Integer, default: 0
  field :used_as_filter, type: Boolean, default: true
  field :cover, type: String

  field :promotion_header, type: String
  field :promotion_footer, type: String

  mount_uploader :cover, CoverUploader

  has_one :banner
  accepts_nested_attributes_for :banner, allow_destroy: true

  has_many :footer_slides, as: :image, class_name: 'Image'
  accepts_nested_attributes_for :footer_slides, allow_destroy: true, reject_if: proc { |attributes| attributes['file'].blank? }

  has_many :products, inverse_of: :brand

  scope :with_package_sets, -> { where(:id.in => package_set_brand_ids) }
  scope :with_services, -> { where(:id.in => services_brand_ids) }
  scope :used_as_filters, -> { where(:used_as_filter.ne => false) }

  def package_sets
    PackageSet.with_brand(self)
  end

  def package_sets_referrer_rates_range
    package_sets.map(&:referrer_rate).sort.uniq
  end

  private

    def self.package_set_brand_ids
      PackageSet.active.map(&:brands).flatten.map(&:id)
    end

    def self.services_brand_ids
      Service.active.map(&:brand).compact.map(&:id)
    end
end
