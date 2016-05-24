require 'singleton'

class Settings
  include Singleton
  include MongoidBase

  field :exchange_rate_to_yuan, type: BigDecimal, default: 8
  field :platform_currency,     type: ISO4217::Currency,  default: 'CNY'

  def self.instance
    @rate ||= Settings.first_or_create()
  end

  private_class_method :create
end