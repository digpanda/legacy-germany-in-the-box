class LockedValidator < ActiveModel::Validator

  attr_reader :record

  def setup(record)
    @record = record
  end

  def validate(record)
    setup(record)
    if locked_order?
      record.errors.add(:base, error)
    end
  end

  private

  def error
    "This order is locked."
  end

  # depending where we start the validation (order or order item)
  # we check differently the hierarchy
  def locked_order?
    case record.class
    when OrderItem
      if record.order.locked
        true
      end
    when Order
      if record.locked
        true
      end
    else
      false
    end
  end

end
