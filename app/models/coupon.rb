require 'will_paginate/array'

class Coupon
  include MongoidBase
  include ActiveModel::Validations
  include Mongoid::Search

  # research system
  search_in :id, :code, :desc, :discount, :last_applied_at, :c_at, :u_at, referrer: :reference_id

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
  field :origin, type: Symbol, default: :default

  # not to mix up with origin, this is the type of coupon, which is the used for it when it's categorized
  field :group, type: Symbol, default: :default

  field :expired_at, type: Time

  scope :not_expired, -> { any_of({:expired_at.gt => Time.now.utc}, {expired_at: nil}) }

  has_many :orders

  belongs_to :referrer, class_name: 'Referrer', inverse_of: :coupons
  belongs_to :shop, inverse_of: :coupons
  belongs_to :user, inverse_of: :coupons

  validates :code, uniqueness: true
  validates :discount, presence: true
  validates :unit, presence: true, inclusion: { in: [:percent, :value] }
  validates :unique, presence: true

  # save before save to ensure code even if empty
  before_save :ensure_code

  def ensure_code
    unless code.present?
      self.code = Coupon.available_code
    end
  end

  # i've over-done it with this quite simple validation
  # to make an example of validator
  validates_with CouponReachedMinimumOrder

  def cancelled?
    cancelled_at.present?
  end

  def self.available_code
    code = SecureRandom.hex(4)[0, 4]
    if Coupon.where(code: code).first
      available_code
    else
      code
    end
  end
end
