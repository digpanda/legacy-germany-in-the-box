module PathsHelper
  # NOTE : for remote / latest version
  # use 'https://unpkg.com/vue'
  def resolve_vuejs_path
    if Rails.env.production? || Rails.env.test?
      '/javascripts/vue.min.js'
    else
      '/javascripts/vue.js'
    end
  end

  def resolve_profile_path
    if current_user
      if current_user.decorate.new_notifications?
        shared_notifications_path
      else
        edit_customer_account_path
      end
    else
      new_user_session_path
    end
  end

  def section_active?(path)
    url_for.index(path) == 0
  end

  def package_sets_section?
    section_active? guest_package_sets_path
  end

  def services_section?
    section_active? guest_services_path
  end

  def general_section?
    PathMatcher.new(request).include?([guest_products_path, guest_shops_path, guest_search_path]) || root_path?
  end

  def root_path?
    request.path == root_path
  end

  def admin_path?
    PathMatcher.new(request).include?(['/admin'])
  end

  def shopkeeper_path?
    PathMatcher.new(request).include?(['/shopkeeper'])
  end

  def customer_path?
    PathMatcher.new(request).include?(['/customer'])
  end

  def guest_path?
    PathMatcher.new(request).include?(['/guest'])
  end
end
