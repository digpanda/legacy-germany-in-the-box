class ShippingRate
  include MongoidBase

  field :weight, type: Float, default: 0
  field :price, type: Float, default: 0
  field :type, type: Symbol, default: :general # special case for milk powder, etc.
  field :partner, type: Symbol, default: :xipost

end
