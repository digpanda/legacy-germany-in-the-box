class OrderTracking
  include MongoidBase
  include Mongoid::Search

  # research system
  search_in :id, :c_at

  field :unique_id, type: String
  field :status, type: Symbol #
  field :histories, type: Hash # all the history of the tracking so far
  field :refreshed_at, type: Time

  belongs_to :order, inverse_of: :tracking

end
