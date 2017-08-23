require 'iso4217/currency_mongoid'

class Shop
  include MongoidBase
  include Mongoid::Slug

  Numeric.include CoreExtensions::Numeric::CurrencyLibrary

  strip_attributes

  field :approved,        type: Time
  field :name,            type: String
  slug :name

  field :shopname,        type: String,     localize: true
  field :desc,            type: String,     localize: true
  field :logo,            type: String
  field :banner,          type: String

  field :philosophy,      type: String,     localize: true
  field :stories,         type: String,     localize: true
  field :uniqueness,      type: String,     localize: true
  field :german_essence,  type: String,     localize: true
  field :founding_year,   type: String

  field :tax_number,      type: String
  field :ustid,           type: String
  field :eroi,            type: String
  field :min_total,       type: BigDecimal, default: 0
  field :status,          type: Boolean,    default: true
  field :register,        type: String
  field :website,         type: String
  field :agb,             type: Boolean

  field :position, type: Integer, default: 0

  field :seal0,           type: String
  field :seal1,           type: String
  field :seal2,           type: String
  field :seal3,           type: String
  field :seal4,           type: String
  field :seal5,           type: String
  field :seal6,           type: String
  field :seal7,           type: String

  field :fname, type: String
  field :lname, type: String
  field :mail,            type: String

  field :merchant_id,     type: String
  field :highlight,       type: Boolean, default: false

  mount_uploader :logo,   LogoUploader
  mount_uploader :banner, CoverUploader

  mount_uploader :seal0,   ProductUploader
  mount_uploader :seal1,   ProductUploader
  mount_uploader :seal2,   ProductUploader
  mount_uploader :seal3,   ProductUploader
  mount_uploader :seal4,   ProductUploader
  mount_uploader :seal5,   ProductUploader
  mount_uploader :seal6,   ProductUploader
  mount_uploader :seal7,   ProductUploader

  embeds_many :addresses,   inverse_of: :shop

  has_many  :products,        inverse_of: :shop,  dependent: :restrict
  has_many  :orders,          inverse_of: :shop,  dependent: :restrict
  has_many  :coupons,         inverse_of: :shop,  dependent: :restrict
  has_many  :payment_gateways,  inverse_of: :shop,  dependent: :restrict
  has_many  :package_sets, inverse_of: :shop, dependent: :restrict

  belongs_to :shopkeeper,   class_name: 'User',  inverse_of: :shop

  validates :name,          presence: true,   length: {maximum: (Rails.configuration.gitb[:max_tiny_text_length] * 1.25).round}
  validates :status,        presence: true
  validates :min_total,     presence: true,   numericality: { :greater_than_or_equal_to => 0 }
  validates :shopkeeper,    presence: true
  validates :founding_year, presence: true,   length: {maximum: 4}
  validates :desc,          presence: true,   length: {maximum: (Rails.configuration.gitb[:max_medium_text_length] * 1.25).round}
  validates :philosophy,    presence: true,   length: { maximum: (Rails.configuration.gitb[:max_long_text_length] * 1.25).round }
  validates :ustid,         presence: true,   length: { maximum: Rails.configuration.gitb[:max_tiny_text_length] },   if: lambda { self.agb }

  validates :agb, inclusion: {in: [true]},    if: lambda { self.agb.present? }

  validates :register,        length: { maximum: Rails.configuration.gitb[:max_tiny_text_length] }
  validates :stories,         length: { maximum: (Rails.configuration.gitb[:max_long_text_length] * 1.25).round }
  validates :website,         length: {maximum: (Rails.configuration.gitb[:max_short_text_length] * 1.25).round}
  validates :eroi,            length: { maximum: Rails.configuration.gitb[:max_tiny_text_length] }
  validates :uniqueness,      length: {maximum: (Rails.configuration.gitb[:max_medium_text_length] * 1.25).round}
  validates :german_essence,  length: {maximum: (Rails.configuration.gitb[:max_medium_text_length] * 1.25).round}
  validates :shopname,        length: { maximum: Rails.configuration.gitb[:max_short_text_length] }

  validates :mail,          presence: false,   length: { maximum: Rails.configuration.gitb[:max_short_text_length] }

  scope :is_active,       ->    { where( status: true ).where( :approved.ne => nil ) }
  scope :has_address, -> { where({ :addresses => { :$not => { :$size => 0 } } }) }

  scope :can_buy,         ->    { is_active }
  scope :highlighted,     ->    { where(highlight: true) }

  before_save :ensure_shopkeeper
  before_save :force_merchant_id

  def force_merchant_id
    if self.merchant_id.nil?
      self.merchant_id = (self.c_at ? self.c_at.strftime('%y%m%d') : Date.today.strftime('%y%m%d')) + self.name.delete("\s")[0, 3].upcase
    end
  end

  def billing_address
    addresses.is_billing.first
  end

  def sender_address
    addresses.is_shipping.first
  end

  def country
    sender_address = addresses.find_sender
    sender_address ? sender_address.country : nil
  end

  def country_of_dispatcher
    sender_address.country
  end

  # TODO : check if it's still in use within the system
  # - Laurent, 05/07/2017
  def categories
    all_categories = Category.order_by(position: :asc).all.map { |c| [c.id, c] }.to_h
    products.inject(Set.new) { |cs, p| cs = cs + p.category_ids }.map { |c| all_categories[c] }
  end

  def payment_method?(payment_method)
    self.payment_gateways.map(&:payment_method).include? payment_method
  end

  def discount?
    self.products.discount_products
  end

  def can_buy?
    active? && addresses.is_shipping.count > 0
  end

  def active?
    status == true && approved != nil
  end

  private

    def ensure_shopkeeper
      shopkeeper.role == :shopkeeper
    end

    # TODO : should be refactored / cleaned
    def self.with_can_buy_products
      self.in(id: Product.can_buy.map { |p| p.shop_id }).all
    end
end
