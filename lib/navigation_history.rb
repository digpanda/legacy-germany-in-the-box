# manage the navigation history
# gets back to previous pages easily
class NavigationHistory

  DEFAULT_REDIRECT_URL = Rails.application.routes.url_helpers.root_url
  BASE_EXCEPT = %w(/users/sign_in /users/sign_up /users/password/new /users/password/edit /users/confirmation /users/sign_out)

  attr_reader :request, :session

  def initialize(request, session)
    @request = request
    @session = session
  end

  def store(location)
    NavigationHistory::Store.new(request, session, location).add(BASE_EXCEPT)
  end

  def store_current
    NavigationHistory::Store.new(request, session, request.url).add(BASE_EXCEPT)
  end

  def back(raw_position=1, default_redirect=nil)
    position = raw_position-1
    if history_found?(position)
      session[:previous_urls][position]
    else
      default_redirect || DEFAULT_REDIRECT_URL
    end
  end

  private

  def history_found?(position)
    session[:previous_urls].is_a?(Array) && session[:previous_urls][position].present?
  end

end
