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
    AppCache.get_second_last_ui_category_branches_from_cache.include?(self.id)
  end
end