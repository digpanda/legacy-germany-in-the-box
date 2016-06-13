class DutyAndCustomerCategorySelectStore

  def initialize(class_name)
    @classz = Object.const_get(class_name)
  end

  def grouped_categories_options(locale)
    Rails.cache.fetch("grouped_categories_options_#{locale}") {
      second_last_branches.sort {|a,b| a.name <=> b.name } .map {|c| [c.name_translations[locale], children(c).map { |cc| [cc.name_translations[locale], cc.id.to_s] }, c.id.to_s] }
    }
  end

  private

  def categories
    @categories ||= @classz.all.is_active.to_a.map { |c| [c.id.to_s, c] }.to_h
  end

  def second_last_branches
    @second_last_branches ||= categories.values.select { |c| c.children_count == 0 } .map { |c| categories[c.parent_id.to_s] }.compact.uniq

    if @second_last_branches.size == 0
      categories.values
    else
      @second_last_branches
    end
  end

  def children(category)
    categories_by_parent[category.id.to_s]
  end

  def categories_by_parent
    @categories_by_parent ||=
        categories.values.each_with_object(Hash.new{ |h,v| h[v] = [] }) do |category, memo|
            memo[category.parent_id.to_s] << category
        end
  end
end