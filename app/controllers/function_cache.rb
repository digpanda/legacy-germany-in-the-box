module FunctionCache

  def get_root_level_categories_from_cache
    Rails.cache.fetch("all_root_level_categories_cache", :expires_in => Rails.configuration.products_search_cache_expire_limit ) {
      root_level_categories = Category.where( :parent => nil )
      root_level_categories.collect { |c| c.children.count > 1 ? c : c.children.first }
    }
  end

  def get_first_level_categories_from_cache(root)
    Rails.cache.fetch("first_level_categories_cache_of_root_leve_#{root.id}", :expires_in => Rails.configuration.products_search_cache_expire_limit ) {
      root.children.to_a.sort! { |a,b| a.children.count <=> b.children.count }.reverse!
    }
  end

  def get_number_of_different_products_from_cache(first_level_category)
    Rails.cache.fetch("number_of_different_products_cache_of_first_level_#{first_level_category.id}", :expires_in => Rails.configuration.products_search_cache_expire_limit ) {
      if first_level_category.parent.present?
        products.count
      else
        first_level_category.children.inject(0) { |sum, child| sum += child.products.count }
      end
    }
  end

  def get_second_level_categories_from_cache(first_level_category)
    Rails.cache.fetch("second_level_categories_cache_of_first_level_category_#{first_level_category.id}", :expires_in => Rails.configuration.products_search_cache_expire_limit ) {
      first_level_category.children.to_a
    }
  end

  def get_products_from_search_cache(term, page = 0)
    searched_products = get_products_from_search_cache_for_term(term)

    products_from_products = sort_and_map_products(searched_products[:products].first(Rails.configuration.limit_for_products_search), I18n.t(:product, scope: :popular_products))
    products_from_brands = sort_and_map_products(searched_products[:brands].first(Rails.configuration.limit_for_products_search),  I18n.t(:brand, scope: :popular_products))
    products_from_categories =  sort_and_map_products(searched_products[:categories].first(Rails.configuration.limit_for_products_search),  I18n.t(:category, scope: :popular_products))
    products_from_tags = sort_and_map_products(searched_products[:tags].first(Rails.configuration.limit_for_products_search),  I18n.t(:tag, scope: :popular_products))

    products_from_tags + products_from_products + products_from_brands + products_from_categories
  end

  def get_products_from_search_cache_for_term(term)
    magic_number = generate_magic_number

    Rails.cache.fetch("products_search_cache_#{term}_#{magic_number}", :expires_in => Rails.configuration.products_search_cache_expire_limit ) {
      products_from_products = Product.where({ name: /.*#{term}.*/i }).sort_by {Random.rand}

      products_from_brands = Product.where({ brand: /.*#{term}.*/i }).sort_by {Random.rand}

      products_from_categories =  []
      Category.where( { name: /.*#{term}.*/i } ).each do |c|
        products_from_categories |=  c.products
      end

      products_from_categories.sort_by {Random.rand}

      products_from_tags = Product.where( { :tags => term } ).sort_by {Random.rand}

      { tags: products_from_tags, products: products_from_products, brands: products_from_brands, categories: products_from_categories }
    }
  end

  def get_popular_proudcts_from_cache
    magic_number = generate_magic_number

    Rails.cache.fetch("popular_products_cache_#{magic_number}", :expires_in => Rails.configuration.popular_products_cache_expire_limit ) {
      Product.all.sort_by { Random.rand }
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
end