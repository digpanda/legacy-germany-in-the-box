class CategoryNavigation

  def categories
    @categories ||= Category.only_with_products.to_a
  end

  def roots
    @roots ||= 
      categories.select do |category|
        category.parent_id.nil?
      end
  end

  def sub_tree(category)
    children(category).inject("") do |memo, child| # We should refacto this code and put the HTML in a view
      memo << "<li class=\"dir\"><a href=\"#{Rails.application.routes.url_helpers.show_products_in_category_path(child.id)}\">#{child.name}</a>"
      memo << "<ul>#{sub_tree(child)}</ul>" if has_children?(child)
      memo << "</li>"
    end.html_safe
  end

  private

  def has_children?(category)
    categories_by_parent[category.id.to_s].any?
  end

  def children(category)
    categories_by_parent[category.id.to_s]
  end

  def categories_by_parent
    @categories_by_parent ||= 
      categories.each_with_object(Hash.new{ |h,v| h[v] = [] }) do |category, memo|
        memo[category.parent_id.to_s] << category
      end
  end

end