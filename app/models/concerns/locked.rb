module Locked
  extend ActiveSupport::Concern

  attr_accessor :bypass_locked

  included do
    field :locked, type: Boolean, default: false
    # locked `order` cannot be modified
    # NOTE : if we extend the locking system
    # we should change the validaton as well
    validates_with LockedValidator, unless: :bypass_locked

  end

  def lock!
    self.locked = true
    # we remove the validation to lock the order
    self.bypass_locked!
    self.save
  end

  # not currently in use in the system
  # it was made to counter balance the `lock!`
  def unlock!
    self.locked = false
    self.save
  end

  def bypass_locked!
    self.bypass_locked = true
    self.order_items.each do |order_item|
      order_item.bypass_locked = true
    end
  end

end
