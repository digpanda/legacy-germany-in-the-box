require 'singleton'

class Settings
  include Singleton
  include MongoidBase

  field :exchange_rate_to_yuan, type: BigDecimal, default: 8

  validates :exchange_rate_to_yuan,   presence: true,   :numericality => { :greater_than => 0 }

  def initialize(*args)
    @settings = super(*args)
    self.save!
    @settings
  end
end