# By Loschcode (should be way improved and turned into a gem or something)
module NavigationHistoryHelper

  def store_navigation_history(conditions)

    return unless request.get? # Only GETs
    return if request.xhr? # AJAX cal

    exception_path = conditions[:except] || []
    return if exception_path.include? request.path

    session[:previous_url] = request.fullpath 
    session[:previous_urls] = [] if session[:previous_urls].nil?
    session[:previous_urls].unshift session[:previous_url] unless session[:previous_urls].first == session[:previous_url]

  end

  def navigation_history(n=1, default_redirect=nil)

    if default_redirect.nil?
      default_redirect = root_path
    end

    array_n = n-1
    if !session[:previous_urls].is_a? Array || session[:previous_urls][array_n].nil?
      default_redirect
    else
      session[:previous_urls][array_n]
    end

  end

end
