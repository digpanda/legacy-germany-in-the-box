class WeixinTicketCache
  include MongoidBase
  EXPIRATION_TIME = -> { 2.hours }

  strip_attributes
  field :ticket, type: String
  field :domain, type: String

  scope :still_valid, -> { where(c_at: { '$gt': Time.now - EXPIRATION_TIME.call }) }
  scope :with_scope, -> (scope) { where(scope: scope) }

end
