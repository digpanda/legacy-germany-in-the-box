class LockedValidator < ActiveModel::Validator
  attr_reader :record

  def setup(record)
    @record = record
  end

  def validate(record, ignore_changes: false)
    setup(record)
    # if there were any change on the model itself
    # NOTE : sometimes it pass to the validation without change
    # it can make problem when modifiying the model embedding the one with the lock system
    if (record.changes.present? || ignore_changes) && locked_entry?
      record.errors.add(:base, error)
    end
  end

  private

    def error
      'This entry is locked.'
    end

    # depending where we start the validation
    # we check differently the hierarchy
    def locked_entry?
      record.locked === true
    end
end
