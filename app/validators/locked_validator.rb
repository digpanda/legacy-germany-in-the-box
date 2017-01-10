class LockedValidator < ActiveModel::Validator

  attr_reader :record

  def setup(record)
    @record = record
  end

  def validate(record)
    setup(record)
    if locked_entry?
      record.errors.add(:base, error)
    end
  end

  private

  def error
    "This entry is locked."
  end

  # depending where we start the validation
  # we check differently the hierarchy
  def locked_entry?
    if record.locked
        true
    else
      false
    end
  end

end
