module FunctionCache

  def get_root_level_categories_from_cache
    Rails.cache.fetch("all_root_level_categories_cache_#{I18n.locale}", :expires_in => Rails.configuration.products_search_cache_expire_limit ) {
      root_level_categories = Category.roots.is_active.to_a.sort { |a,b| a.get_locale_name <=> b.get_locale_name }
      root_level_categories.select { |c| c.children.count > 1 ? c : c.children.first }
    }
  end

  def get_first_level_categories_from_cache(root)
    Rails.cache.fetch("first_level_categories_cache_of_root_leve_#{root.id}_#{I18n.locale}", :expires_in => Rails.configuration.products_search_cache_expire_limit ) {
      root.children.is_active.to_a.sort { |a,b| a.get_locale_name <=> b.get_locale_name }
    }
  end

  def get_number_of_different_products_from_cache(first_level_category)
    Rails.cache.fetch("number_of_different_products_cache_of_first_level_#{first_level_category.id}", :expires_in => Rails.configuration.products_search_cache_expire_limit ) {
      if first_level_category.parent.present?
        products.count
      else
        first_level_category.children.is_active.inject(0) { |sum, child| sum += child.products.count }
      end
    }
  end

  def get_second_level_categories_from_cache(first_level_category)
    Rails.cache.fetch("second_level_categories_cache_of_first_level_category_#{first_level_category.id}_#{I18n.locale}", :expires_in => Rails.configuration.products_search_cache_expire_limit ) {
      first_level_category.children.is_active.to_a.sort { |a,b| a.get_locale_name <=> b.get_locale_name }
    }
  end

  def get_products_for_autocompletion(term, page = 1)
    founded_products = get_products_from_search_cache_for_term(term)

    limit = Rails.configuration.limit_for_products_search

    products_from_products = sort_and_map_products(founded_products[:products][(page - 1) * limit, limit], I18n.t(:product, scope: :popular_products))
    products_from_brands = sort_and_map_products(founded_products[:brands][(page - 1) * limit, limit],  I18n.t(:brand, scope: :popular_products))
    products_from_categories =  sort_and_map_products(founded_products[:categories][(page - 1) * limit, limit],  I18n.t(:category, scope: :popular_products))
    products_from_tags = sort_and_map_products(founded_products[:tags][(page - 1) * limit, limit],  I18n.t(:tag, scope: :popular_products))

    products_from_tags + products_from_products + products_from_brands + products_from_categories
  end

  def get_products_from_search_cache_for_term(term)
    magic_number = generate_magic_number

    Rails.cache.fetch("products_search_cache_#{term}_#{magic_number}", :expires_in => Rails.configuration.products_search_cache_expire_limit ) {
      products_from_products = Product.is_active.where({ name: /.*#{term}.*/i }).sort_by {Random.rand}

      products_from_brands = Product.is_active.where({ brand: /.*#{term}.*/i }).sort_by {Random.rand}

      products_from_categories =  []
      Category.is_active.where( { name: /.*#{term}.*/i } ).each do |c|
        products_from_categories |=  c.products.is_active
      end

      products_from_categories.sort_by {Random.rand}

      products_from_tags = Product.is_active.where( { :tags => term } ).sort_by {Random.rand}

      { tags: products_from_tags, products: products_from_products, brands: products_from_brands, categories: products_from_categories }
    }
  end

  def get_popular_proudcts_from_cache
    magic_number = generate_magic_number

    Rails.cache.fetch("popular_products_cache_#{magic_number}", :expires_in => Rails.configuration.popular_products_cache_expire_limit ) {
      Product.is_active.all.sort_by { Random.rand }
    }
  end

  def sort_and_map_products(products, search_category)
    products.sort_by { |a| a.name }.map { |p| {:label => p.name, :value => p.name, :sc => search_category, :product_id => p.id } }
  end

  def generate_magic_number
   (session.id ? session.id.to_s.sum : current_user.authentication_token.sum) % Rails.configuration.max_magic_number
  end

  def get_category_values_for_left_menu(products)
    categories_and_children = {}
    categories_and_counters = {}

    products.each do |p|
      p.categories.each do |c|
        if not categories_and_children.has_key?(c.parent)
          categories_and_children[c.parent] = []
          categories_and_counters[c] = 0
          categories_and_counters[c.parent] = 0
        end

        categories_and_children[c.parent] << c if not categories_and_children[c.parent].include?(c)
        categories_and_counters[c] += 1
        categories_and_counters[c.parent] += 1
      end
    end

    return categories_and_children, categories_and_counters
  end

  def get_grouped_categories_options_from_cache
    Rails.cache.fetch("get_grouped_categories_options_from_cache_#{I18n.locale}", :expires_in => Rails.configuration.popular_products_cache_expire_limit ) {
      categories = []

      Category.roots.is_active.each do |rc|
        if not rc.next_2_last_branche?
          categories += rc.children.is_active
        else
          categories << rc
        end
      end

      categories.sort {|a,b| b.total_products <=> a.total_products } .map {|rc| [rc.get_locale_name, rc.children.is_active.sort { |a,b| b.total_products <=> a.total_products }.map {|cc| [cc.get_locale_name, cc.id.to_s]} ] }.to_a
    }
  end

  def get_grouped_variants_options_from_cache(p)
    Rails.cache.fetch("get_grouped_variants_options_from_cache_#{p.id}_#{I18n.locale}", :expires_in => Rails.configuration.popular_products_cache_expire_limit ) {
      p.options.map { |v| [v.get_locale_name, v.suboptions.sort { |a,b| a.get_locale_name <=> b.get_locale_name }.map { |o| [ o.get_locale_name, o.id.to_s]}] }.to_a
    }
  end
end