# storage system for navigation history
class NavigationHistory
  class Store

    MAX_HISTORY = 10

    attr_reader :request, :session

    def initialize(request, session)
      @request = request
      @session = session
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

    def location
      @location ||= begin
        if location == :current
          request.url
        else
          location
        end
      end
    end

    def location_path
      @location_path ||= begin
        if location
          uri_location.path + uri_location.query
        else
          request.fullpath
        end
      end
    end

    def uri_location
      URI(location)
    end

    def excluded_path?(excluded_paths=[])
      excluded_paths.each do |path|
        return true if location_path.index(path) == 0
      end
      false
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
