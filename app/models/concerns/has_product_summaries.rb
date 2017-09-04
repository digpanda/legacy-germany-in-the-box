module HasProductSummaries

  def self.included(base)
    def base.summarizes(sku_list:, by:)
      mattr_accessor(:sku_list_identifier) { sku_list }
      mattr_accessor(:quantity_attr) { by }
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

  # here we can make all the calculations for the dimensional weight
  # TODO : is it still in use ? if so, place it elsewhere
  def total_dimensional_weight
    # 100.00 <--- testing
    sku_list.inject(0) { |sum, i| sum += (i.sku.space_length) * (i.sku.space_width) * (i.sku.space_height) * i.quantity } / 5000
  end

  private

    def sku_list
      send(sku_list_identifier)
    end
end
