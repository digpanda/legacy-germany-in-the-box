class ShippingRate
  include MongoidBase

  field :weight, type: Float, default: 0
  field :price, type: Float, default: 0
  # special case for milk powder, etc.
  # NOTE : be careful while changing that
  # please also update ShippingPrice library accordingly
  field :type, type: Symbol, default: :general
  field :partner, type: Symbol
end
