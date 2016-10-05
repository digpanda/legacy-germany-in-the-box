require 'will_paginate/array'

class Coupon
  include MongoidBase

  field :code, type: String
  field :discount, type: Float
  field :desc, type: String
  field :unit, type: Symbol # [:percent, :value]
  field :minimum_order, type: Float
  field :unique, type: Boolean

  has_many :orders

  validates :code, presence: true
  validates :discount, presence: true
  validates :unit, presence: true
  validates :unique, presence: true

end
