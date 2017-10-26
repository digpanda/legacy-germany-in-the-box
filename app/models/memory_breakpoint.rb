class MemoryBreakpoint
  include MongoidBase

  strip_attributes

  field :breakpoint,        type: Symbol

  # this will be erased progressively with a cron job
  field :valid_until, type: Time

  belongs_to :user

  scope :still_valid, -> { where(:valid_until.lt => Time.now.utc) }

end
