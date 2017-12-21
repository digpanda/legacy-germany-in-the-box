class Category
  include MongoidBase
  include CategoryBase
  include EntryPosition
  include Mongoid::Slug

  has_and_belongs_to_many :products,  inverse_of: :categories
  has_many :package_sets,  inverse_of: :category

  # slug_name is here to be used with the Mongoid::Slug system
  # we can find('slug') as an ID and it'll match with slug_name
  # please do not remove or change it without knowing
  # the implication within the system
  # such as the filters in the package sets area.
  field :slug_name, type: String
  slug :slug_name, history: true

  field :desc, type: String, localize: true
  field :position, type: Integer
  field :show, type: Boolean, default: true
  field :cover,       type: String

  mount_uploader :cover, CoverUploader

  has_many :header_slides, as: :image, class_name: 'Image'
  accepts_nested_attributes_for :header_slides, allow_destroy: true, reject_if: proc { |attributes| attributes['file'].blank? }

  has_one :banner
  accepts_nested_attributes_for :banner, allow_destroy: true

  scope :only_with_products,       ->    { where(:product_ids.ne => nil).and(:product_ids.ne => []) }
  scope :with_package_sets, -> { where(:id.in => PackageSet.active.all.pluck(:category_id)) }
  scope :showable, -> { where(:show.ne => false) }

  def products_brands
    products.active.map(&:brand).uniq
  end

  def package_sets_brands
    Brand.where(:id.in => package_set_brand_ids)
  end

  def package_set_brand_ids
    package_sets.active.map(&:brands).flatten.uniq.map(&:_id)
  end

  def shops
    Shop.where(:id.in => shop_ids)
  end

  def can_buy_shops(limit = 0)
    Shop.can_buy.where(:id.in => shop_ids).limit(limit)
  end

  private

    def shop_ids
      Product.where(category_ids: self.id).pluck(:shop_id).uniq
    end
end
