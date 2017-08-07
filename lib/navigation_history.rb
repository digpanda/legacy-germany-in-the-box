# manage the navigation history
# gets back to previous pages easily
class NavigationHistory
  DEFAULT_REDIRECT_URL = Rails.application.routes.url_helpers.root_url.freeze

  attr_reader :request, :session, :repository

  def initialize(request, session, repository = 'default')
    @request = request
    @session = session
    @repository = repository
  end

  # store the location
  # can be :current for the current page
  def store(location, option = nil)
    NavigationHistory::Store.new(request, session, repository, location).add(option)
  end

  def back(raw_position = 1, default_redirect = nil)
    position = raw_position - 1
    if history_found?(position)
      session['previous_urls'][repository][position]
    else
      default_redirect || DEFAULT_REDIRECT_URL
    end
  end

  def reset!
    session['previous_urls'] = {}
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
      session['previous_urls'].is_a?(Hash) && session['previous_urls'][repository].is_a?(Array) && session['previous_urls'][repository][position].present?
    end
end
