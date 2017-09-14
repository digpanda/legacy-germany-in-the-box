class EventCache
  include MongoidBase

  field :stream,            type: String
  field :cache_id,            type: String

end
