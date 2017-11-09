class MemoryBreakpoint
  include MongoidBase

  strip_attributes

  field :request_key, type: String
  field :class_trace, type: String # trace to the class
  field :subclass_trace, type: String # subclass target

  # this will be erased progressively with a cron job
  field :valid_until, type: Time

  belongs_to :user

  scope :still_valid, -> { where(:valid_until.gt => Time.now.utc) }

  # validates :request_key, presence: true <-- could be empty.
  validates :class_trace, presence: true

end
