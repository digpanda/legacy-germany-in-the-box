module HasProductSummaries

  def self.included(base)
    def base.summarizes(sku_list:, by:)
      mattr_accessor(:sku_list_identifier){ sku_list }
      mattr_accessor(:quantity_attr){ by }
    end
  end

  def total_value
    sku_list.inject(0) do |sum, current|
      sum += current.price * current.send(quantity_attr)
    end
  end

  def total_weight
    sku_list.inject(0) do |sum, current|
      sum += current.weight * current.send(quantity_attr)
    end
  end

  def dimensional_weight
    total_weight
  end

  private

  def sku_list
    send sku_list_identifier
  end

end
