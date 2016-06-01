require 'singleton'

class Settings
  include Singleton
  include MongoidBase

  field :exchange_rate_to_yuan, type: BigDecimal, default: 7.6
  field :platform_currency,     type: ISO4217::Currency,  default: 'CNY'
  field :max_total_per_day,    type: BigDecimal, default: 1000

  validates :platform_currency,       presence: true
  validates :exchange_rate_to_yuan,   presence: true,   :numericality => { :greater_than => 0 }
  validates :max_total_per_day,       presence: true,   :numericality => { :greater_than => 0 }

  def self.instance
    @rate ||= Settings.first_or_create()
  end

  private_class_method :create
end