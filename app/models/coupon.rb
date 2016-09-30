require 'will_paginate/array'

class Coupon
  include MongoidBase

  field :code, type: String
  field :discount, type: Float
  field :desc, type: String
  field :unit, type: Symbol # [:percent, :value]
  field :minimum_order, type: Float
  field :unique, type: Boolean

  belongs_to :order
  belongs_to :user

end
