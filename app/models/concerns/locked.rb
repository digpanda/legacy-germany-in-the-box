module Locked
  extend ActiveSupport::Concern

  included do
    field :locked, type: Boolean, default: false
    # locked `order` cannot be modified
    # NOTE : if we extend the locking system
    # we should change the validaton as well
    validates_with LockedValidator

  end

  def lock!
    self.locked = true
    # we remove the validation to lock the order
    self.save(validate: false)
  end

  # not currently in use in the system
  # it was made to counter balance the `lock!`
  def unlock!
    self.locked = false
    self.save
  end
end
