class UniquePackageSkuValidator < ActiveModel::Validator
  attr_reader :record

  def setup(record)
    @record = record
  end

  def validate(record)
    setup(record)
    unless unique_package_sku?
      record.errors.add(:base, error)
    end
  end

  private

    def error
      'You can\'t choose the same sku twice for one package set.'
    end

    def unique_package_sku?
      sku_ids == sku_ids.uniq
    end

    def sku_ids
      @sku_ids ||= record.package_skus.each.map(&:sku_id)
    end
end
