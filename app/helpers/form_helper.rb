module FormHelper

  def category_package_set_filter
    Category.with_package_sets.map do |category|
      [category.name, category.slug, {'data-href' => guest_package_sets_path(category_slug: category.slug)}]
    end
  end

  def brand_package_set_filter
    Brand.with_package_sets.used_as_filters.map do |brand|
      [brand.name, brand.id, {'data-href' => guest_package_sets_path(brand_id: brand.id)}]
    end
  end

  def brand_package_set_filter_with_category(category)
    category.package_sets_brands.map do |brand|
      [brand.name, brand.id, {'data-href' => guest_package_sets_path(category_slug: category.slug, brand_id: brand.id)}]
    end
  end

  def guess_coupon_label
    if session[:origin] == :wechat
      I18n.t('coupon.coupon_mobile')
    else
      I18n.t('coupon.coupon_desktop')
    end
  end

  def every(form, limit)
    (form.index + 1) % limit == 0
  end

  def solve_index
    @solve_index = 0 unless @solve_index
    @solve_index += 1
  end

end
