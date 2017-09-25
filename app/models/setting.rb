require 'singleton'

class Setting
  include Singleton
  include MongoidBase

  field :exchange_rate_to_yuan, type: BigDecimal, default: 7.6
  field :platform_currency,     type: ISO4217::Currency, default: ISO4217::Currency.from_code('CNY')
  field :supplier_currency,     type: ISO4217::Currency, default: ISO4217::Currency.from_code('EUR')
  field :max_total_per_day,     type: BigDecimal, default: 1000
  field :alert, type: String

  field :logistic_partner, type: Symbol, default: :manual

  field :search_suggestion, type: String

  field :package_sets_title,       type: String
  field :package_sets_description, type: String
  field :package_sets_link, type: String
  field :package_sets_button, type: String
  field :package_sets_cover,       type: String
  mount_uploader :package_sets_cover, CoverUploader

  field :package_sets_highlight,     type: Boolean
  field :current_version, type: Symbol, default: :stable # [:alpha, :beta, :stable]

  field :landing_page_title,       type: String
  field :landing_page_description, type: String
  field :landing_page_link, type: String
  field :landing_page_button, type: String
  field :landing_page_cover,       type: String
  mount_uploader :landing_page_cover, CoverUploader

  field :landing_page_highlight,     type: Boolean

  field :default_coupon_discount, type: Float, default: 0

  field :force_referrer_groups, type: Boolean, default: false
  field :referrer_money_claim, type: Float, default: 10.0

  validates :platform_currency,       presence: true
  validates :supplier_currency,       presence: true
  validates :exchange_rate_to_yuan,   presence: true,   numericality: { greater_than: 0 }
  validates :max_total_per_day,       presence: true,   numericality: { greater_than: 0 }

  def self.instance
    @instance ||= Setting.first_or_create
  end

  # we overwrite the `create!` method so it forces to actually
  # recreate a new instance and reset the memoization
  def self.create!(*args)
    @instance = Setting.first_or_create(*args)
  end

  private_class_method :create
end
