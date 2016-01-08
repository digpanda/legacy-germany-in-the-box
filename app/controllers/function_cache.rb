module FunctionCache

  def get_root_level_categories_from_cache
    Rails.cache.fetch("all_root_level_categories_cache", :expires_in => Rails.configuration.product_search_cache_expire_limit ) {
      Category.where( :parent => nil )
    }
  end

  def get_first_level_categories_from_cache(root)
    Rails.cache.fetch("first_level_categories_cache_of_root_leve_#{root.id}", :expires_in => Rails.configuration.product_search_cache_expire_limit ) {
      root.children.to_a.sort! { |a,b| a.children.count <=> b.children.count }.reverse!
    }
  end

  def get_number_of_different_products_from_cache(first_level_category)
    Rails.cache.fetch("number_of_different_products_cache_of_first_level_#{first_level_category.id}", :expires_in => Rails.configuration.product_search_cache_expire_limit ) {
      if first_level_category.parent.present?
        products.count
      else
        first_level_category.children.inject(0) { |sum, child| sum += child.products.count }
      end
    }
  end

  def get_second_level_categories_from_cache(first_level_category)
    Rails.cache.fetch("second_level_categories_cache_of_first_level_category_#{first_level_category.id}", :expires_in => Rails.configuration.product_search_cache_expire_limit ) {
      first_level_category.children.to_a
    }
  end

  def get_products_from_search_cache(term)
    Rails.cache.fetch("products_search_cache_#{term}", :expires_in => Rails.configuration.product_search_cache_expire_limit ) {
      products_from_products = sort_and_map_products(Product.where({ name: /.*#{term}.*/i }).limit(Rails.configuration.autocomplete_limit), :product)

      products_from_brands = sort_and_map_products(Product.where({ brand: /.*#{term}.*/i }).limit(Rails.configuration.autocomplete_limit), :brand)
      products_from_categories =  []

      Category.where( { name: /.*#{term}.*/i } ).limit(Rails.configuration.autocomplete_limit).to_a.each do |c|
        products_from_categories |=  sort_and_map_products(c.products, :category)
      end

      products_from_tags = sort_and_map_products( Product.where( { :tags => term } ).limit(Rails.configuration.autocomplete_limit), :keyword )

      products_from_tags + products_from_products + products_from_brands + products_from_categories
    }
  end

  def sort_and_map_products(products, search_category)
    products.sort! { |a,b| a.name.downcase <=> b.name.downcase }.map { |p| {:label => p.name, :value => p.name, :sc => search_category, :obj => p } }
  end
end