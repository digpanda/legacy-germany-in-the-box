class PackageSet
  include MongoidBase
  include EntryPosition

  field :position, type: Integer, default: 0
  field :name, type: String
  field :desc, type: String
  field :long_desc, type: String
  field :cover,       type: String
  field :details_cover,       type: String
  field :referrer_rate, type: Float, default: 0.0

  mount_uploader :cover, CoverUploader
  mount_uploader :details_cover, CoverUploader

  belongs_to :shop, inverse_of: :package_sets
  embeds_many :package_skus, inverse_of: :package_set, cascade_callbacks: true
  embeds_many :images, inverse_of: :package_set, cascade_callbacks: true
  has_many :order_items

  accepts_nested_attributes_for :package_skus, :reject_if => :reject_package_skus, :allow_destroy => true
  accepts_nested_attributes_for :images, :allow_destroy => true

  def reject_package_skus(attributed)
    attributed['product_id'].blank? || attributed['sku_id'].blank?
  end

  validates_presence_of :name
  validates_presence_of :desc
  validates_presence_of :cover
  validates_with UniquePackageSkuValidator

  def casual_price
    self.package_skus.reduce(0) do |acc, package_sku|
      acc + (package_sku.sku.price_with_taxes_and_shipping * package_sku.quantity)
    end
  end

  def price
    self.package_skus.reduce(0) do |acc, package_sku|
      acc + package_sku.total_price_with_taxes
    end
  end

  def end_price
    self.package_skus.reduce(0) do |acc, package_sku|
      acc + package_sku.total_price_with_taxes_and_shipping
    end
  end

end
