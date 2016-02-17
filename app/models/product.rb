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
  field :img0,        type: String
  field :img1,        type: String
  field :img2,        type: String
  field :img3,        type: String
  field :price,       type: BigDecimal
  field :sale,        type: Integer
  field :currency,    type: String,     default: 'EUR'
  field :status,      type: String
  field :desc,        type: String
  field :weight,      type: Float
  field :tags,        type: Array
  field :limited,     type: Boolean,    default: true
  field :inventory,   type: Integer
  field :individual,  type: Boolean,    default: false
  field :discount,    type: BigDecimal, default: 0

  has_and_belongs_to_many :users,       inverse_of: :products
  has_and_belongs_to_many :collections, inverse_of: :products
  has_and_belongs_to_many :categories,  inverse_of: :products

  has_many :order_items,  inverse_of: :product

  belongs_to :shop, inverse_of: :products

  mount_uploader :img0,   AttachmentUploader
  mount_uploader :img1,   AttachmentUploader
  mount_uploader :img2,   AttachmentUploader
  mount_uploader :img3,   AttachmentUploader

  validates :name,        presence: true
  validates :brand ,      presence: true
  validates :price,       presence: true
  validates :currency,    presence: true, inclusion: {in: ['EUR']}
  validates :shop,        presence: true
  validates :limited,     presence: true
  validates :discount,    presence: true, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 1 }
  validates :inventory,   presence: true, :numericality => { :greater_than_or_equal_to => 0 }, :if => lambda { self.limited }

  scope :has_tag, ->(value) { where(:tags => value) }
  
  index({brand: 1}, {unique: false})
  index({name: 1},  {unique: false})
  index({tags: 1},  {unique: false})
end