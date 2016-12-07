require 'iso4217/currency_mongoid'

class PaymentGateway
  include MongoidBase

  strip_attributes

  field :provider, type: Symbol
  field :merchant_id, type: String # `maid` in wirecard
  field :merchant_secret, type: String # `secret` in wirecard
  field :payment_method, type: Symbol # ``:upop` or ``:creditcard`

  belongs_to :shop, inverse_of: :payment_gateways

  validates :provider, inclusion: {:in => [:wirecard]}
  validates :payment_method, inclusion: {:in => [:creditcard, :upop, :paypal]}


end
