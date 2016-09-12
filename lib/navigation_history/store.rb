# storage system for navigation history
class NavigationHistory
  class Store

    MAX_HISTORY = 10

    attr_reader :request, :session, :location

    def initialize(request, session, location)
      @request = request
      @session = session
      @location = location
    end

    def add(conditions={})

      return false unless acceptable_request?
      return false if excluded_path?(conditions)

      # could be a new class but it's useless right now
      prepare_storage
      add_storage
      limit_storage!

      session[:previous_urls]

    end

    private

    def location_path
      @location_path ||= URI(location).path || request.fullpath
    end

    def excluded_path?(conditions)
      excluded_paths = conditions[:except] || []
      excluded_paths.include? location_path
    end

    def acceptable_request?
      location_path
    end

    def already_last_stored?
      session[:previous_urls].first == location_path
    end

    def prepare_storage
      session[:previous_urls] ||= [] # we need it because we use session
    end

    def add_storage
      unless already_last_stored?
        session[:previous_urls].unshift(location_path)
      end
    end

    def limit_storage!
      session[:previous_urls].pop if session[:previous_urls].size > MAX_HISTORY
    end

  end
end
