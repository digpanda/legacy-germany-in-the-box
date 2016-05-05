class Category
  include MongoidBase
  include CategoryBase

  has_and_belongs_to_many :products,  :inverse_of => :categories

  def total_products
    if children.size > 0
      children.is_active.inject(0) { |sum, c| sum += c.total_products }
    else
      product_ids ? product_ids.size : 0
    end
  end

  def second_last_branche?
    return false if products.size > 0

    if children.size > 0
      return nil == children.detect { |c| c.children.size > 0 }
    end

    return false
  end
end