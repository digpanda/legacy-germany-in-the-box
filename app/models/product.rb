class Product
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  strip_attributes

  field :network,     type: String
  field :prodid,      type: String
  field :deeplink,    type: String
  field :name,        type: String
  field :brand,       type: String
  field :img,         type: String
  field :desc,        type: String
  field :tags,        type: Array

  embeds_many :variants,  inverse_of: :product
  embeds_many :skus,      inverse_of: :product

  has_and_belongs_to_many :users,       inverse_of: :products
  has_and_belongs_to_many :collections, inverse_of: :products
  has_and_belongs_to_many :categories,  inverse_of: :products

  has_many :order_items,  inverse_of: :product

  belongs_to :shop, inverse_of: :products

  validates :name,        presence: true
  validates :brand ,      presence: true
  validates :shop,        presence: true
  validates :variants,    presence: true
  validates :skus,        presence: true

  scope :has_tag, ->(value) { where(:tags => value) }
  
  index({brand: 1}, {unique: false})
  index({name: 1},  {unique: false})
  index({tags: 1},  {unique: false})
end