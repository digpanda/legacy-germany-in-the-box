class Address
  include MongoidBase

  CHINESE_CHARACTERS = /[\u4e00-\u9fa5]+/
  CHINESE_ID = /(\d{6})(19|20)(\d{2})(1[0-2]|0[1-9])(0[1-9]|[1-2][0-9]|3[0-1])(\d{3})(\d|X|x)/

  strip_attributes

  # field :additional,    type: String
  # field :number,        type: String
  # field :street,        type: String
  # field :district,      type: String
  # field :city,          type: String
  # field :province,      type: String
  # field :zip,           type: String

  field :full_address

  field :country,       type: ISO3166::Country
  field :type,          type: Symbol, default: :both
  field :company,       type: String

  field :fname,         type: String
  field :lname,         type: String
  field :pid,           type: String
  field :email,         type: String
  field :mobile,        type: String
  field :primary,       type: Boolean, default: false

  embedded_in :shop, inverse_of: :addresses
  embedded_in :user, inverse_of: :addresses

  embedded_in :order, inverse_of: :billing_address
  embedded_in :order, inverse_of: :shipping_address

  scope :is_billing,          ->  { any_of({ type: :billing }, { type: :both }) }
  scope :is_shipping,         ->  { any_of({ type: :shipping },  { type: :both }) }
  scope :is_any,              ->  { any_of({ type: :shipping },  { type: :billing }, { type: :both }) }

  scope :is_only_billing,     ->  { any_of(type: :billing) }
  scope :is_only_shipping,    ->  { any_of(type: :shipping) }
  scope :is_only_both,        ->  { any_of(type: :both) }

  validates :mobile, presence: true, if: -> { user&.customer? }
  validates :pid, presence: true, if: -> { user&.customer? }
  validates :fname, presence: true#, :format => { :with => CHINESE_CHARACTERS }, if: -> { user&.customer? }
  validates :lname, presence: true#, :format => { :with => CHINESE_CHARACTERS }, if: -> { user&.customer? }

  # validates :street, presence: true
  # validates :city, presence: true
  # validates :zip, presence: true
  validates :country, presence: true
  validates :company, presence: true, if: -> { shop.present? }
  # validates :province, presence: true
  validates :type, presence: true , inclusion: { in: [:billing, :shipping, :both] }

  before_save :ensure_valid_mobile

  def ensure_valid_mobile
    if mobile
      mobile.gsub!(/[[:space:]]/, '')
    end
  end

  def country_code
    country&.alpha2
  end

  def country_name
    country&.name
  end

  def country_local_name
    country&.local_name
  end
end
