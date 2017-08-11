class Link
  include MongoidBase
  include Mongoid::Search

  field :title, type: String
  field :url, type: String
  field :position, type: Integer, default: 0
  field :valid_url, type: Boolean, default: true

  # research system
  search_in :title, :url

end
