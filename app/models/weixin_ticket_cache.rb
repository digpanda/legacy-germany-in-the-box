class WeixinTicketCache
  include MongoidBase
  EXPIRATION_TIME = -> { 2.hours }

  strip_attributes
  field :ticket, type: String
  field :cache_scope, type: String

  scope :still_valid, -> { where(c_at: { '$gt': Time.now - EXPIRATION_TIME.call }) }
  scope :with_cache_scope, -> (cache_scope) { where(cache_scope: cache_scope) }

end
