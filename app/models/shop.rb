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
  field :min_total,       type: BigDecimal, default: 0
  field :currency,        type: String,     default: '€'

  field :status,          type: Symbol,     default: :new

  mount_uploader :logo,   AttachmentUploader
  mount_uploader :banner, AttachmentUploader

  has_one   :bank_account,  inverse_of: :shop,  dependent: :restrict
  has_one   :address,       inverse_of: :shop,  dependent: :restrict

  has_many  :products,  inverse_of: :shop,  dependent: :restrict

  belongs_to :shopkeeper,   class_name: 'User',  inverse_of: :shop

  validates :name,          presence: true
  validates :sms,           presence: true
  validates :sms_mobile,    presence: true,   :if => lambda { self.sms }
  validates :address,       presence: true,   :if => lambda { self.status == :opened }
  validates :bank_account,  presence: true,   :if => lambda { self.status == :opened }
  validates :status,        presence: true,   inclusion: {in: [:new, :opened, :closed]}
  validates :min_total,     presence: true
  validates :shopkeeper,    presence: true
  validates :currency,      presence: true,   inclusion: {in: ['€']}

  validates :ustid,         length: { minimum: 25, maximum: 25, :allow_blank => true }
  validates :story,         length: { minimum: 25, maximum: 25, :allow_blank => true }

  before_save :ensure_shopkeeper

  private

  def ensure_shopkeeper
    shopkeeper.role == :shopkeeper
  end
end