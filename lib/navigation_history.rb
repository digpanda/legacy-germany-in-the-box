# manage the navigation history
# gets back to previous pages easily
class NavigationHistory

  MAX_HISTORY = 10
  DEFAULT_REDIRECT_URL = Rails.application.routes.url_helpers.root_url

  attr_reader :request, :session

  def initialize(request, session)
    @request = request
    @session = session
  end

  def store(location, conditions={})

    location = location_path(location)
    return false unless acceptable_request?(location)
    return false if excluded_path?(location, conditions)

    # could be a new class but it's useless right now
    prepare_storage
    add_storage(location)
    limit_storage!

    session[:previous_urls]

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

  def location_path(location)
    URI(location).path
  end

  def history_found?(position)
    session[:previous_urls].is_a?(Array) && session[:previous_urls][position].present?
  end

  def excluded_path?(location, conditions)
    excluded_paths = conditions[:except] || []
    excluded_paths.include? location
  end

  def acceptable_request?(location)
    location || (request.get? && !request.xhr?) # GET and not AJAX
  end

  def already_last_stored?(location)
    session[:previous_urls].first == (location || request.fullpath)
  end

  def prepare_storage
    session[:previous_urls] ||= [] # we need it because we use session
  end

  def add_storage(location)
    unless already_last_stored?(location)
      session[:previous_urls].unshift (location || request.fullpath)
    end
  end

  def limit_storage!
    session[:previous_urls].pop if session[:previous_urls].size > MAX_HISTORY
  end

end
