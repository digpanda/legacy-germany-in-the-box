# manage the navigation history
# gets back to previous pages easily
class NavigationHistory

  attr_reader :request, :session

  include Rails.application.routes.url_helpers
  
  def initialize(request, session)
    @request = request
    @session = session
  end

  def store(conditions)

    return unless request.get? # Only GETs
    return if request.xhr? # AJAX call

    exception_path = conditions[:except] || []
    return if exception_path.include? request.path

    session[:previous_url] = request.fullpath 
    session[:previous_urls] = [] if session[:previous_urls].nil?
    session[:previous_urls].unshift session[:previous_url] unless session[:previous_urls].first == session[:previous_url]

    if session[:previous_urls].size > 10
      session[:previous_urls].pop # poping last element if too big
    end

  end

  def back(n=1, default_redirect=nil)

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
