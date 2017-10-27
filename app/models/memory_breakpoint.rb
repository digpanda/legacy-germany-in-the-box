class MemoryBreakpoint
  include MongoidBase

  strip_attributes

  field :breakpoint, type: Array # ["keyword1", "keyword2"]
  field :trace, type: Array # the array to go inside scheme until the correct keyword

  # this will be erased progressively with a cron job
  field :valid_until, type: Time

  belongs_to :user

  scope :still_valid, -> { where(:valid_until.gt => Time.now.utc) }

end
