require 'will_paginate/array'

class Coupon
  include MongoidBase
  include ActiveModel::Validations
  Numeric.include CoreExtensions::Numeric::CurrencyLibrary

  field :code, type: String
  field :discount, type: Float
  field :desc, type: String
  field :unit, type: Symbol
  field :minimum_order, type: Float, default: 0
  field :unique, type: Boolean
  field :last_applied_at, type: Time
  field :last_used_at, type: Time
  field :cancelled_at, type: Time, default: false
  field :exclude_china, type: Boolean, default: false

  has_many :orders

  belongs_to :referrer, :class_name => "User", :inverse_of => :referrer_coupons

  validates :code, presence: true, uniqueness: true
  validates :discount, presence: true
  validates :unit, presence: true, inclusion: {in: [:percent, :value]}
  validates :unique, presence: true

  # i've over-done it with this quite simple validation
  # to make an example of validator
  validates_with CouponReachedMinimumOrder

  def cancelled?
    cancelled_at.present?
  end

  def self.create_referrer_coupon(referrer)
    Coupon.create({
                      :code => SecureRandom.hex(4)[0,4],
                      :unit => :percent,
                      :discount => Setting.instance.referrers_rate,
                      :minimum_order => 0,
                      :unique => false,
                      :desc => 'Referrer Coupon',
                      :referrer => referrer,
                      :exclude_china => true
                  })
  end

end
