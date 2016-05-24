require 'singleton'

class Settings
  include Singleton
  include MongoidBase

  field :exchange_rate_to_yuan, type: BigDecimal, default: 8

  @@instance ||= Settings.first_or_create()

  private_class_method :create
end