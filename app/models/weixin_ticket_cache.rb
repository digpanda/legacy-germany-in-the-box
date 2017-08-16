class WeixinTicketCache
  include MongoidBase
  EXPIRATION_TIME = -> { 2.hours }

  strip_attributes
  field :ticket, type: String

  scope :still_valid, -> { where(c_at: { '$gt': Time.now - EXPIRATION_TIME.call }) }
  
end
