module HasProductSummaries

  def self.included(base)
    def base.summarizes(product_list:, by:)
      mattr_accessor(:product_list_identifier){ product_list }
      mattr_accessor(:quantity_attr){ by }
    end
  end

  def total_value
    product_list.inject(0) do |sum, current|
      sum += current.price * current.send(quantity_attr)
    end
  end

  def total_weight
    product_list.inject(0) do |sum, current|
      sum += current.weight_in_kg * current.send(quantity_attr)
    end
  end

  private

  def product_list
    send product_list_identifier
  end

end
