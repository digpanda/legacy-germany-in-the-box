class Shop
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Timestamps::Updated::Short

  include DocLocaleName

  strip_attributes

  field :name,            type: String
  field :shopname,        type: String
  field :desc,            type: String
  field :logo,            type: String
  field :banner,          type: String
  field :philosophy,      type: String
  field :stories,         type: String
  field :ustid,           type: String
  field :eroi,            type: String
  field :sms,             type: Boolean,    default: false
  field :sms_mobile,      type: String
  field :min_total,       type: BigDecimal, default: 0
  field :currency,        type: String,     default: '€'
  field :status,          type: Boolean,    default: true
  field :founding_year,   type: String
  field :uniqueness,      type: String
  field :german_essence,  type: String
  field :target_groups,   type: Array,      default: []
  field :sales_channels,  type: Array,      default: []
  field :register,        type: String
  field :website,         type: String
  field :statement0,      type: Boolean
  field :statement1,      type: Boolean
  field :statement2,      type: Boolean
  field :agb,             type: Boolean,    default: false

  field :name_locales,    type: Hash

  mount_uploader :logo,   AttachmentUploader
  mount_uploader :banner, AttachmentUploader

  has_one   :bank_account,    inverse_of: :shop,  dependent: :restrict

  has_many  :addresses,       inverse_of: :shop,  dependent: :restrict
  has_many  :products,        inverse_of: :shop,  dependent: :restrict

  belongs_to :shopkeeper,   class_name: 'User',  inverse_of: :shop

  validates :name,          presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :shopname,      presence: true,   length: {maximum: Rails.configuration.max_short_text_length}
  validates :sms,           presence: true
  validates :sms_mobile,    presence: true,   :if => lambda { self.sms }, length: {maximum: Rails.configuration.max_tiny_text_length}
  #validates :billing_address,       presence: true,   :if => lambda { self.status == :opened }
  #validates :bank_account,  presence: true,   :if => lambda { self.status == :opened }
  validates :status,        presence: true
  validates :min_total,     presence: true,   numericality: { :greater_than_or_equal_to => 0 }
  validates :shopkeeper,    presence: true
  validates :currency,      presence: true,   inclusion: {in: ['€']}
  validates :founding_year, presence: true,   length: {maximum: 4}
  validates :register,      presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :desc,          presence: true,   length: {maximum: Rails.configuration.max_medium_text_length}
  validates :philosophy,    presence: true,   length: {maximum: Rails.configuration.max_medium_text_length}
  validates :stories,       presence: true,   length: {maximum: Rails.configuration.max_long_text_length}
  validates :statement0,    presence: true
  validates :statement1,    presence: true
  validates :statement2,    presence: true
  validates :agb,           presence: true

  validates :website,       length: {maximum: Rails.configuration.max_short_text_length}

  validates :ustid,         length: { maximum: Rails.configuration.max_tiny_text_length}
  validates :eroi,          length: { maximum: Rails.configuration.max_tiny_text_length}

  validates :uniqueness,      length: { maximum: Rails.configuration.max_medium_text_length}
  validates :german_essence,  length: { maximum: Rails.configuration.max_medium_text_length}

  scope :is_active,       ->        { where( :status => true ) }

  before_save :ensure_shopkeeper
  before_save :ensure_agb
  before_save :clean_sms_mobile, :unless => lambda { self.sms }

  before_validation :ensure_shopname

  private

  def ensure_shopname
    self.shopname = self.name unless self.shopname
  end

  def ensure_agb
    self.agb = true if self.agb.present?
  end

  def ensure_shopkeeper
    shopkeeper.role == :shopkeeper
  end

  def clean_sms_mobile
    self.sms_mobile = nil
  end

end