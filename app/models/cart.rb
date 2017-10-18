require 'will_paginate/array'

class Cart
  include MongoidBase

  has_many :orders, counter_cache: :orders_count
  belongs_to :user

  # NOTE : this could be way more optimized than currently ...
  scope :with_orders, -> { any_in(:_id => includes(:orders).select{ |cart| cart.orders.size > 0 }.map(&:id)) }
end
