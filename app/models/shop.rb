class Shop
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  strip_attributes

  field :name,            type: String
  field :desc,            type: String
  field :logo,            type: String
  field :banner,          type: String
  field :philosophy,      type: String
  field :story,           type: String
  field :ustid,           type: String
  field :eroi,            type: String
  field :sms,             type: Boolean,    default: false
  field :sms_mobile,      type: String
  field :min_value,       type: BigDecimal

  field :status,          type: Symbol,     default: :new

  mount_uploader :logo,   AttachmentUploader
  mount_uploader :banner, AttachmentUploader

  has_one   :bank_account
  has_one   :address
  has_many  :products,    inverse_of: :shop

  validates :name,        presence: true
  validates :sms,         presence: true
  validates :ustid,       presence: false,  length: { minimum: 25, maximum: 25 }
  validates :story,       presence: false,  length: { minimum: 25, maximum: 25 }
  validates :sms_mobile,  presence: false,  :unless => lambda { self.sms }
  validates :address,     presence: true
  validates :status,      presence: true,   inclusion: {in: [:new, :opened, :closed]}
end