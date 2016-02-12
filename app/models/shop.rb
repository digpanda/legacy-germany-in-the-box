
class Shop
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  strip_attributes

  field :name,        type: String
  field :desc,        type: String
  field :logo,        type: String
  field :banner,      type: String
  field :philosophy,  type: String
  field :story,       type: String
  field :ustid,       type: String
  field :eroi,        type: String
  field :sms,         type: Boolean,  default: false

  has_one :bank_account

  validates :name,    presence: true
  validates :sms,     presence: true
  validates :ustid,   presence: false,  length: { minimum: 25, maximum: 25 }
  validates :story,   presence: false,  length: { minimum: 25, maximum: 25 }

  has_many :products, inverse_of: :shop

  mount_uploader :logo, AttachmentUploader
  mount_uploader :banner, AttachmentUploader
end