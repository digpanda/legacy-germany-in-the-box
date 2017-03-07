class ShippingRate
  include MongoidBase

  field :weight, type: Float
  field :price, type: Float
  field :type, type: Symbol, default: :general # special case for milk powder, etc.

end
