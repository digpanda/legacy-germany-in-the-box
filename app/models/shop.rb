class Shop
  include MongoidBase

  strip_attributes

  field :name,            type: String
  field :shopname,        type: String,     localize: true
  field :desc,            type: String,     localize: true
  field :logo,            type: String
  field :banner,          type: String
  field :philosophy,      type: String,     localize: true
  field :stories,         type: String,     localize: true
  field :tax_number,      type: String
  field :ustid,           type: String
  field :eroi,            type: String
  field :sms,             type: Boolean,    default: false
  field :sms_mobile,      type: String
  field :min_total,       type: BigDecimal, default: 0
  field :currency,        type: String,     default: '€'
  field :status,          type: Boolean,    default: true
  field :founding_year,   type: String
  field :uniqueness,      type: String,     localize: true
  field :german_essence,  type: String,     localize: true
  field :sales_channels,  type: Array,      default: []
  field :register,        type: String
  field :website,         type: String
  field :agb,             type: Boolean
  field :seal0,           type: String
  field :seal1,           type: String
  field :seal2,           type: String
  field :seal3,           type: String
  field :seal4,           type: String
  field :seal5,           type: String
  field :seal6,           type: String
  field :seal7,           type: String

  mount_uploader :logo,   LogoImageUploader
  mount_uploader :banner, BannerImageUploader

  mount_uploader :seal0,   ProductImageUploader
  mount_uploader :seal1,   ProductImageUploader
  mount_uploader :seal2,   ProductImageUploader
  mount_uploader :seal3,   ProductImageUploader
  mount_uploader :seal4,   ProductImageUploader
  mount_uploader :seal5,   ProductImageUploader
  mount_uploader :seal6,   ProductImageUploader
  mount_uploader :seal7,   ProductImageUploader

  has_one   :bank_account,    inverse_of: :shop

  has_many  :addresses,       inverse_of: :shop
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
  validates :philosophy,    presence: true,   length: {maximum: (Rails.configuration.max_long_text_length * 1.25).round}
  validates :tax_number,    presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length },   :if => lambda { self.agb }
  validates :ustid,         presence: true,   length: {maximum: Rails.configuration.max_tiny_text_length },   :if => lambda { self.agb }

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