class DutyAndCustomerCategorySelectStore

  def initialize(class_name)
    @classz = Object.const_get(class_name)
  end

  def categories
    @categories ||= @classz.all.is_active.to_a
  end

  def grouped_categories_options(locale)
    @grouped_categories_options ||= {}
    @grouped_categories_options[locale] = second_last_branches.sort {|a,b| a.name <=> b.name } .map {|rc| [rc.name_translations, children(rc).sort { |a,b| a.name <=> b.name }.map {|cc| [cc.decorate.name_translations, cc.id.to_s]} ] }.map { |c| [c[0][locale], c[1].map { |cc| [cc[0][locale], cc[1]]} ]}
  end

  def total_products(category)
    if category.children_count > 0
      children(category).inject(0) { |sum, c| sum += total_products(c) }
    else
      category.product_ids ? category.product_ids.size : 0
    end
  end

  def second_last_branches
    @second_last_branches ||= categories.select { |c| c.children_count == 0 } .map { |c| categories.detect { |p| p.id.to_s == c.parent_id.to_s } }.uniq
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