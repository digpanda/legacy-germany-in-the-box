require 'iso4217/currency_mongoid'

class Shop
  include MongoidBase

  strip_attributes

  field :approved,        type: Time
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
  field :status,          type: Boolean,    default: true
  field :founding_year,   type: String
  field :uniqueness,      type: String,     localize: true
  field :german_essence,  type: String,     localize: true
  field :sales_channels,  type: Array,      default: []
  field :register,        type: String
  field :website,         type: String
  field :agb,             type: Boolean
  field :wirecard_status, type: Symbol
  field :seal0,           type: String
  field :seal1,           type: String
  field :seal2,           type: String
  field :seal3,           type: String
  field :seal4,           type: String
  field :seal5,           type: String
  field :seal6,           type: String
  field :seal7,           type: String

  field :currency,        type: ISO4217::Currency,  default: 'EUR'

  field :fname,           type: String
  field :lname,           type: String
  field :mobile,          type: String
  field :tel,             type: String
  field :mail,            type: String
  field :function,        type: String

  field :merchant_id,     type: String
  field :bg_merchant_id,  type: String

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

  has_many :addresses,   inverse_of: :shop

  has_many  :products,        inverse_of: :shop,  dependent: :restrict
  has_many  :orders,          inverse_of: :shop,  dependent: :restrict

  belongs_to :shopkeeper,   class_name: 'User',  inverse_of: :shop

  validates :name,          presence: true,   length: {maximum: (Rails.configuration.max_tiny_text_length * 1.25).round}
  validates :sms,           presence: true
  validates :sms_mobile,    presence: true,   :if => lambda { self.sms }, length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :status,        presence: true
  validates :min_total,     presence: true,   numericality: { :greater_than_or_equal_to => 0 }
  validates :shopkeeper,    presence: true
  validates :currency,      presence: true
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
  #validates :sales_channels,  length: {minimum: 2, maximum: Rails.configuration.max_num_sales_channels * 2}

  # This seems to be systematically empty, should we keep the fields ? - Laurent on 02/06/2016 (i changed to presence: false)
  validates :fname,         presence: false,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :lname,         presence: false,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :tel,           presence: false,   length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :mail,          presence: false,   length: {maximum: Rails.configuration.max_short_text_length}

  validates :mobile,        length: {maximum: Rails.configuration.max_tiny_text_length}
  validates :function,      length: {maximum: Rails.configuration.max_tiny_text_length}

  scope :is_active,       ->    { where( :status => true ).where( :approved.ne => nil ) }
  scope :has_address,     ->    { self.in({:id => Address.is_sender.all.map(&:shop_id)}) }
  scope :is_bg_merchant,  ->    { where(:bg_merchant_id.ne => nil) }
  scope :buyable,         ->    { is_active.is_bg_merchant.has_address }

  before_save :ensure_shopkeeper
  before_save :clean_sms_mobile,  :unless => lambda { self.sms }

  index({shopkeeper: 1},    {unique: true,   name: :idx_shop_shopkeeper})
  index({merchant_id: 1},   {unique: false,  name: :idx_shop_merchant_id})

  def gen_merchant_id
    (self.c_at ? self.c_at.strftime('%y%m%d') : Date.today.strftime('%y%m%d')) + self.name[0,3].upcase
  end

  def billing_address
    addresses.is_billing.first
  end

  def sender_address
    addresses.is_sender.first
  end

  def country
    sender_address = addresses.find_sender
    sender_address ? sender_address.country : nil
  end

  def country_of_dispatcher
    sender_address.country
  end

  def categories
    all_categories = Category.all.map { |c| [c.id, c]}.to_h
    products.inject(Set.new) {|cs, p| cs = cs + p.category_ids }.map { |c| all_categories[c]}
  end

  private

  def ensure_shopkeeper
    shopkeeper.role == :shopkeeper
  end

  def clean_sms_mobile
    self.sms_mobile = nil
  end

  def self.with_buyable_products
    self.in(id: Product.buyable.map {|p| p.shop_id } ).all
  end

end