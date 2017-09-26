module Locked
  extend ActiveSupport::Concern

  attr_reader :bypass_locked

  included do
    field :locked, type: Boolean, default: false
    # locked `order_item` cannot be modified
    validates_with LockedValidator, unless: :bypass_locked
    # we also can't remove a locked `order_item`
    before_destroy :validate_not_locked
  end

  def validate_not_locked
    LockedValidator.new.validate(self, ignore_changes: true).nil?
  end

  def locked?
    self.locked
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
  end
end
