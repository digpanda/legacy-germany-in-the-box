class PackageSet
  include MongoidBase
  include EntryPosition
  include Mongoid::Search
  include Mongoid::Slug

  field :position, type: Integer, default: 0

  field :name, type: String
  slug :name

  field :desc, type: String
  field :long_desc, type: String
  field :promotion_text, type: String
  field :cover,       type: String
  field :details_cover,       type: String
  field :referrer_rate, type: Float, default: 0.0
  field :active, type: Boolean, default: true
  field :casual_price, type: Float, default: 0
  field :shipping_cost, type: Float, default: 0

  mount_uploader :cover, CoverUploader
  mount_uploader :details_cover, CoverUploader

  belongs_to :shop, inverse_of: :package_sets
  belongs_to :category, inverse_of: :package_sets

  embeds_many :package_skus, inverse_of: :package_set, cascade_callbacks: true

  has_many :order_items
  has_many :images, as: :image

  # research system
  search_in :name, :desc, shop: :shopname, category: :name

  accepts_nested_attributes_for :package_skus, reject_if: :reject_package_skus, allow_destroy: true
  accepts_nested_attributes_for :images, allow_destroy: true

  def reject_package_skus(attributed)
    attributed['product_id'].blank? || attributed['sku_id'].blank?
  end

  validates_presence_of :name
  validates_presence_of :desc
  validates_presence_of :cover
  validates_with UniquePackageSkuValidator

  scope :active, -> { where(active: true) }
  scope :with_category, -> (category) { where(category: category) }

  scope :with_brand, -> (brand) do
    product_ids = Product.where(brand_id: brand.id).map(&:_id)
    where(package_skus: { '$elemMatch': { 'product_id.in': product_ids } })
  end

  # array of brands for this package set
  def brands
    self.package_skus.map(&:product).map(&:brand)
  end

  def casual_price?
    casual_price && casual_price > 0
  end

  def price
    self.package_skus.reduce(0) do |acc, package_sku|
      acc + package_sku.total_price_with_taxes
    end
  end

  def end_price
    total_price_with_taxes + total_shipping
  end

  def total_price_with_taxes
    self.package_skus.reduce(0) do |acc, package_sku|
      acc + package_sku.total_price_with_taxes
    end
  end

  def total_shipping
    shipping_cost
  end

  def delete_with_assoc
    delete_oder_items
    if self.order_items.empty?
      self.destroy
    else
      self.update(active: false)
    end
  end

  def delete_oder_items
    self.order_items.each do |order_item|
      order_item.delete unless order_item.order.bought?
    end
  end
end
