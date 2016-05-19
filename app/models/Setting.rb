class Setting
  include MongoidBase

  field :exchange_rate_to_yuan, type: BigDecimal, default: 8

  validates :exchange_rate_to_yuan,   presence: true,   :numericality => { :greater_than => 0 }
end