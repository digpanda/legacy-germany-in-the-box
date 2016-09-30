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

    def add(exceptions=nil, option=nil)

      return false unless acceptable_request?
      return false if excluded_path?(exceptions)

      # force add a session and force the last entered URL
      if option == :force
        session[:force_url] = location_path
      else
        # normal process without force URL
        prepare_storage
        add_storage
        trim_storage
      end

      session[:previous_urls]

    end

    private

    def location_path
      @location_path ||= begin
        if location
          URI(location).path
        else
          request.fullpath
        end
      end
    end

    def excluded_path?(exceptions)
      excluded_paths = exceptions || []
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

    def trim_storage
      session[:previous_urls].pop if session[:previous_urls].size > MAX_HISTORY
    end

  end
end
