# manage the navigation history
# gets back to previous pages easily
class NavigationHistory

  DEFAULT_REDIRECT_URL = Rails.application.routes.url_helpers.root_url
  BASE_EXCEPT = %w(/users/sign_in /users/sign_up /users/password/new /users/password/edit /users/confirmation /users/sign_out)
  FORCE_LIMIT = 5.seconds

  attr_reader :request, :session

  def initialize(request, session)
    @request = request
    @session = session
  end

  # store the location
  # can be :current for the current page
  def store(location, option=nil)
    NavigationHistory::Store.new(request, session, understood(location)).add(BASE_EXCEPT, option)
  end

  def back(raw_position=1, default_redirect=nil)
    position = raw_position-1
    if history_found?(position)
      session[:previous_urls][position]
    else
      default_redirect || DEFAULT_REDIRECT_URL
    end
  end

  # is there any force URL stored ?
  def force?
    session[:force_url] = nil unless acceptable_force_timing?
    session[:force_url] != nil
  end

  # destroy the session force URL and return it
  def force!
    session[:force_time] = Time.now.utc
    force = session[:force_url]
    session[:force_url] = nil
    force
  end

  private

  def acceptable_force_timing?
    return true unless session[:force_time]
    Time.now.utc > (session[:force_time].to_time.utc + FORCE_LIMIT)
  end


  def understood(location)
    if location == :current
      request.url
    else
      location
    end
  end

  def history_found?(position)
    session[:previous_urls].is_a?(Array) && session[:previous_urls][position].present?
  end

end
