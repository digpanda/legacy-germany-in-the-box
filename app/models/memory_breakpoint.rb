class MemoryBreakpoint
  include MongoidBase

  strip_attributes

  field :breakpoint, type: Hash # polymorphic stuff

  # this will be erased progressively with a cron job
  field :valid_until, type: Time

  belongs_to :user

  scope :still_valid, -> { where(:valid_until.gt => Time.now.utc) }

end
