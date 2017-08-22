class Category
  include MongoidBase
  include CategoryBase
  include EntryPosition

  has_and_belongs_to_many :products,  inverse_of: :categories
  has_many :package_sets,  inverse_of: :category

  field :slug, type: String
  field :desc, type: String, localize: true
  field :position, type: Integer
  field :show, type: Boolean, default: true
  field :cover,       type: String

  mount_uploader :cover, CoverUploader

  scope :only_with_products,       ->    { where(:product_ids.ne => nil).and(:product_ids.ne => []) }
  scope :with_package_sets, -> { where(:id.in => PackageSet.active.all.pluck(:category_id)) }
  scope :showable, -> { where(:show.ne => false) }

  def product_brands
    products.is_active.map(&:brand).uniq
  end

  def package_set_brands
    package_sets.active.map(&:brands).flatten.uniq
  end

  def shops
    Shop.where(:id.in => shop_ids)
  end

  def can_buy_shops(limit=0)
    Shop.can_buy.where(:id.in => shop_ids).limit(limit)
  end

  private

  def shop_ids
    Product.where(category_ids: self.id).pluck(:shop_id).uniq
  end
end
