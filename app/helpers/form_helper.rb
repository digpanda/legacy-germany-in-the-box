module FormHelper

  def brand_select(form)
    form.collection_select :brand, Brand.all, :id, :name, { prompt: true, selected: form.object.brand&.id }, class: 'form-control'
  end

  def category_select(form)
    form.select :category, options_from_collection_for_select(Category.all, :id, :name, form.object.category&.id), { include_blank: I18n.t('multiselect.non_selected_text') }, class: 'form-control'
  end

  def categories_select(form)
    form.select :categories, options_from_collection_for_select(Category.all, :id, :name), { include_blank: I18n.t('multiselect.non_selected_text') }, class: 'form-control'
  end

  def category_package_set_filter
    Category.with_package_sets.map do |category|
      [category.name, category.slug_name, 'data-href': guest_package_sets_path(category_id: category.slug)]
    end
  end

  def brand_package_set_filter
    Brand.with_package_sets.used_as_filters.map do |brand|
      [brand.name, brand.slug, 'data-href': guest_package_sets_path(brand_id: brand.slug)]
    end
  end

  def brand_package_set_filter_with_category(category)
    category.package_sets_brands.used_as_filters.map do |brand|
      [brand.name, brand.slug, 'data-href': guest_package_sets_path(category_id: category.slug, brand_id: brand.slug)]
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
