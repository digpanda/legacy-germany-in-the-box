# manage the navigation history
# gets back to previous pages easily
class NavigationHistory

  MAX_HISTORY = 10

  attr_reader :request, :session

  include Rails.application.routes.url_helpers
  
  def initialize(request, session)
    @request = request
    @session = session
  end

  def store(conditions={})

    return false unless request.get? # Only GETs
    return false if request.xhr? # AJAX call

    exception_path = conditions[:except] || []
    return false if exception_path.include? request.path

    session[:previous_url] = request.fullpath 
    session[:previous_urls] = [] if session[:previous_urls].nil?
    session[:previous_urls].unshift session[:previous_url] unless session[:previous_urls].first == session[:previous_url]

    if session[:previous_urls].size > MAX_HISTORY
      session[:previous_urls].pop # poping last element if too big
    end

    session[:previous_urls]
    
  end

  def back(raw_position=1, default_redirect=nil)

    default_redirect = root_path unless default_redirect

    position = raw_position-1
    if !session[:previous_urls].is_a? Array || session[:previous_urls][position].nil?
      default_redirect
    else
      session[:previous_urls][position]
    end

  end

  private
=begin
  def storage
    session[:previous_url] || []
  end

  def storage=(data)
    session[:previous_url] = data
  end
=end
end
