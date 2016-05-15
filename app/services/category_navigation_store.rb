class CategoryNavigationStore

  def categories
    @categories ||= Category.all.to_a # .only_with_products shouldn't be added here 
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

  def grouped_categories_options(locale)
    @grouped_categories_options ||= {}
    @grouped_categories_options[locale] ||= begin
      gco = []

      categories.each do |rc|
        if not second_last_branche?(rc)
          gco += children(rc)
        else
          gco << rc
        end
      end

      gco.sort {|a,b| total_products(b) <=> total_products(a) } .map {|rc| [rc.name_translations, children(rc).sort { |a,b| b.total_products <=> a.total_products }.map {|cc| [cc.name_translations, cc.id.to_s]} ] }.to_a.map { |c| [c[0][locale], c[1].map { |cc| [cc[0][locale], cc[1]]} ]}
    end
  end

  def total_products(category)
    if category.children_count > 0
      children(category).inject(0) { |sum, c| sum += total_products(c) }
    else
      product_ids ? product_ids.size : 0
    end
  end

  private

  def second_last_branche?(category)
    @second_last_branches ||= categories.select { |c| c.children_count == 0 } .map { |c| c.parent.id } .uniq
    @second_last_branches.include?(category.id)
  end

  def has_children?(category)
    categories_by_parent[category.id.to_s].any?
  end

  def children(category)
    categories_by_parent[category.id.to_s]
  end

  def categories_by_parent
    @categories_by_parent ||= 
      categories.each_with_object(Hash.new{ |h,v| h[v] = [] }) do |category, memo|
        unless category.product_ids.empty? # if there's any product in this category we add it to the list
          memo[category.parent_id.to_s] << category
        end
      end
  end

end