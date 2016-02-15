class Product
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  strip_attributes

  field :network,   type: String
  field :prodid,    type: String
  field :deeplink,  type: String
  field :name,      type: String
  field :brand,     type: String
  field :img0,      type: String
  field :img1,      type: String
  field :img2,      type: String
  field :img3,      type: String
  field :price,     type: BigDecimal
  field :sale,      type: Integer
  field :currency,  type: String
  field :status,    type: String
  field :desc,      type: String
  field :weight,    type: Float
  field :tags,      type: Array
  field :limited,   type: Boolea,   default: true
  field :inventory, type: Integer

  has_and_belongs_to_many :users,       inverse_of: :products
  has_and_belongs_to_many :collections, inverse_of: :products
  has_and_belongs_to_many :categories,  inverse_of: :products

  has_many :order_items,  inverse_of: :product

  belongs_to :shop, inverse_of: :products

  validates :name,        presence: true
  validates :brand ,      presence: true
  validates :price,       presence: true
  validates :currency,    presence: true
  validates :shop,        presence: true
  validates :categories,  :length => { :minimum => 1 }
  validates :limited,     presence: true
  validates :inventory,   presence: true, :numericality => { :greater_than => 0 }, :if => lambda { self.limited }

  scope :has_tag, ->(value) { where(:tags => value) }
  
  index({brand: 1}, {unique: false})
  index({name: 1},  {unique: false})
  index({tags: 1},  {unique: false})
end