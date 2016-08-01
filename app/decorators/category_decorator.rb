class CategoryDecorator < Draper::Decorator

  delegate_all
  decorates :category

  def total_products
    if children_count > 0
      children.is_active.inject(0) { |sum, category| sum += category.decorate.total_products }
    else
      product_ids ? product_ids.size : 0
    end
  end

end
