# manage the navigation history
# gets back to previous pages easily
class NavigationHistory

  DEFAULT_REDIRECT_URL = Rails.application.routes.url_helpers.root_url

  # will exclude those paths from the history store. the system is based on implicit wildcard
  # the less precise you are in the paths, the more path and subpath it excludes
  # /connect also means everything inside /connect/ such as /connect/sign_in, etc.
  BASE_EXCEPT = %w(/connect /api/guest/navigation)

  attr_reader :request, :session

  def initialize(request, session)
    @request = request
    @session = session
  end

  # store the location
  # can be :current for the current page
  def store(location, option=nil)
    NavigationHistory::Store.new(request, session).add(BASE_EXCEPT, option)
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
    session[:force_url] != nil
  end

  # destroy the session force URL and return it
  def force!
    force = session[:force_url]
    session[:force_url] = nil
    force
  end

  private

  def history_found?(position)
    session[:previous_urls].is_a?(Array) && session[:previous_urls][position].present?
  end

end
