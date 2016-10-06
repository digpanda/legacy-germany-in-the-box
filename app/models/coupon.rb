require 'will_paginate/array'

class Coupon
  include MongoidBase

  field :code, type: String
  field :discount, type: Float
  field :desc, type: String
  field :unit, type: Symbol # [:percent, :value]
  field :minimum_order, type: Float
  field :unique, type: Boolean
  field :last_used_at, type: Time

  has_many :orders

  validates :code, presence: true
  validates :discount, presence: true
  validates :unit, presence: true, inclusion: {in: [:percent, :value]}
  validates :unique, presence: true
end
