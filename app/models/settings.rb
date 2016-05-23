class Settings
  include MongoidBase

  field :exchange_rate_to_yuan, type: BigDecimal, default: 8

  validates :exchange_rate_to_yuan,   presence: true,   :numericality => { :greater_than => 0 }

  field :singleton_guard, type: Integer
  validates_inclusion_of :singleton_guard, :in => [0]

  def self.instance
    unless single = where(:id => 1).first
      single = Settings.new()
      single.id = 1
      single.singleton_guard = 0
      single.save!
    end

    single
  end
end