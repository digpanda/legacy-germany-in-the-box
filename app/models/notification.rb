class Notification
  include MongoidBase

  strip_attributes

  field :title,    type: String
  field :desc,        type: String
  field :read_at,     type: Time

  belongs_to :user

  validates :title,       presence: true

  scope :unreads, -> { where({:read_at => nil}) }

end