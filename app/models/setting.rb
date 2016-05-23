class Setting
  include MongoidBase

  # acts_as_singleton <-- this was blowing up the staging environment so i commented it, my bad i shouldn't have merge the code without your approval - Laurent

  field :exchange_rate_to_yuan, type: BigDecimal, default: 8

  validates :exchange_rate_to_yuan,   presence: true,   :numericality => { :greater_than => 0 }
end