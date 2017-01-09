module LockedParent
  extend ActiveSupport::Concern

  included do
    before_destroy :not_locked?
    validates_with LockedValidator, unless: :bypass_locked
  end

  def not_locked?
    LockedValidator.new.validate(self).nil?
  end

  # we bypass depending on the bypass_locked value from the `parent`
  # NOTE : right now it's used only for Order and OrderItem (theoretical child)
  def bypass_locked
    case self.class
    when OrderItem
      self.order.bypass_locked
    end
  end

end
