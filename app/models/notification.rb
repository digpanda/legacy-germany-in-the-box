class Notification
  include MongoidBase
  include Mongoid::Search

  strip_attributes

  # research system
  search_in :id, :title, :desc, :read_at, :c_at

  field :title, type: String
  field :desc, type: String
  field :read_at, type: Time
  field :unique_id, type: String

  belongs_to :user

  validates :title, presence: true

  scope :unreads, -> { where(read_at: nil) }

  def read?
    self.read_at
  end

  def read!
    self.read_at = Time.now.utc
    self.save
  end

end
