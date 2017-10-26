class Reward
  include MongoidBase
  include Mongoid::Search

  strip_attributes

  # research system
  search_in :id, :slug, :started_at, :achieved_at, user: :id

  field :task, type: Symbol

  field :started_at, type: Time
  field :ended_at, type: Time

  field :read, type: String

  belongs_to :user

  def to_end?
    !ended_at
  end
end
