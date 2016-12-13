# storage system for navigation history
class NavigationHistory
  class Store

    MAX_HISTORY = 10

    # will exclude those paths from the history store. the system is based on implicit wildcard
    # the less precise you are in the paths, the more path and subpath it excludes
    # /connect also means everything inside /connect/ such as /connect/sign_in, etc.
    EXCLUDED_PATHS = %w(/connect /api/guest/navigation)

    attr_reader :request, :session, :location

    def initialize(request, session, location)
      @request = request
      @session = session
      @location = solve(location)
    end

    def add(option=nil)

      return false unless acceptable_request?
      return false if excluded_path?

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

    def solve(location)
      if location == :current
        request.url
      else
        location
      end
    end

    def location_path
      @location_path ||= begin
        if location
          "#{uri_location.path}#{uri_location.query}"
        else
          request.fullpath
        end
      end
    end

    def uri_location
      URI(location)
    end

    def excluded_path?
      EXCLUDED_PATHS.each do |path|
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
