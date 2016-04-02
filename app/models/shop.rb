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
  field :tax_number,      type: String
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
  field :sales_channels,  type: Array,      default: []
  field :register,        type: String
  field :website,         type: String
  field :statement0,      type: Boolean
  field :statement1,      type: Boolean
  field :statement2,      type: Boolean
  field :agb,             type: Boolean
  field :seal0,           type: String
  field :seal1,           type: String
  field :seal2,           type: String
  field :seal3,           type: String

  field :name_locales,    type: Hash

  mount_uploader :logo,   LogoImageUploader
  mount_uploader :banner, BannerImageUploader

  mount_uploader :seal0,   ProductImageUploader
  mount_uploader :seal1,   ProductImageUploader
  mount_uploader :seal2,   ProductImageUploader
  mount_uploader :seal3,   ProductImageUploader

  has_one   :bank_account,    inverse_of: :shop,  dependent: :restrict

  has_many  :addresses,       inverse_of: :shop,  dependent: :restrict
  has_many  :products,        inverse_of: :shop,  dependent: :restrict

  belongs_to :shopkeeper,   class_name: 'User',  inverse_of: :shop

  validates :name,          presence: true,   length: {maximum: (Rails.configuration.max_tiny_text_length * 1.25).round}
  validates :sms,           presence: true
  validates :sms_mobile,    presence: true,   :if => lambda { self.sms }, length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :status,        presence: true
  validates :min_total,     presence: true,   numericality: { :greater_than_or_equal_to => 0 }
  validates :shopkeeper,    presence: true
  validates :currency,      presence: true,   inclusion: {in: ['€']}
  validates :founding_year, presence: true,   length: {maximum: 4}
  validates :desc,          presence: true,   length: {maximum: (Rails.configuration.max_medium_text_length * 1.25).round}
  validates :philosophy,    presence: true,   length: {maximum: (Rails.configuration.max_medium_text_length * 1.25).round}
  validates :tax_number,    presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length },   :if => lambda { self.agb }
  validates :ustid,         presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length },   :if => lambda { self.agb }

  validates :statement0,    inclusion: {in: [true]},    :if => lambda { self.statement0.present? }
  validates :statement1,    inclusion: {in: [true]},    :if => lambda { self.statement1.present? }
  validates :statement2,    inclusion: {in: [true]},    :if => lambda { self.statement2.present? }
  validates :agb,           inclusion: {in: [true]},    :if => lambda { self.agb.present? }

  validates :register,        length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :stories,         length: {maximum: (Rails.configuration.max_long_text_length * 1.25).round}
  validates :website,         length: {maximum: (Rails.configuration.max_short_text_length * 1.25).round}
  validates :eroi,            length: {maximum: Rails.configuration.max_tiny_text_length }
  validates :uniqueness,      length: {maximum: (Rails.configuration.max_medium_text_length * 1.25).round}
  validates :german_essence,  length: {maximum: (Rails.configuration.max_medium_text_length * 1.25).round}
  validates :shopname,        length: {maximum: Rails.configuration.max_short_text_length }
  validates :sales_channels,  length: {minimum: 2, maximum: Rails.configuration.max_num_sales_channels * 2}

  scope :is_active,       ->        { where( :status => true ) }

  before_save :ensure_shopkeeper
  before_save :clean_sms_mobile, :unless => lambda { self.sms }

  private

  def ensure_shopkeeper
    shopkeeper.role == :shopkeeper
  end

  def clean_sms_mobile
    self.sms_mobile = nil
  end

end