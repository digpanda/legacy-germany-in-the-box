class Reward
  include MongoidBase
  include Mongoid::Search

  strip_attributes

  # research system
  search_in :id, :slug, :desc, :started_at, :achieved_at, user: :id

  field :task, type: Symbol
  field :desc, type: String

  field :started_at, type: Time
  field :achieved_at, type: Time

  # to store interesting data depending the reward
  # could be some coupons id, etc.
  field :reward, type: Hash

  belongs_to :user
end
