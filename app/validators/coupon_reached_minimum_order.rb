class CouponReachedMinimumOrder < ActiveModel::Validator
  attr_reader :record

  def setup(record)
    @record = record
  end

  def validate(record)
    setup(record)
    if value_unit? && wrong_minimum_order?
      record.errors.add(:base, error)
    end
  end

  private

    def error
      'Minimum order must be equal or higher than the discount.'
    end

    def value_unit?
      record.unit == :value
    end

    def wrong_minimum_order?
      record.minimum_order < record.discount
    end
end
