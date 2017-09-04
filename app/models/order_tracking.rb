class OrderTracking
  include MongoidBase
  include Mongoid::Search

  # research system
  search_in :id, :c_at

  field :unique_id, type: String
  field :state, type: Symbol, default: :new # [:new, :processing, :accepted, :problem, :signature_received, :signature_returned, :local_distribution, :returned]
  field :histories, type: Hash # all the history of the tracking so far
  field :refreshed_at, type: Time

  belongs_to :order, inverse_of: :order_tracking

end
