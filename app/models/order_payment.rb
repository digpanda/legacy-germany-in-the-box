class OrderPayment
  include MongoidBase

  field :request_id     , type: String
  field :transaction_id , type: String
  field :transaction_type, type: String
  field :payment_method , type: String
  field :merchant_id    , type: String
  field :status         , type: Symbol, default: :scheduled
  field :amount         , type: Float, default: 0.0
  field :currency       , type: ISO4217::Currency, default: 'EUR'

  belongs_to :order     , :inverse_of => :order_payments, touch: true
  belongs_to :user      , :inverse_of => :orders

end
