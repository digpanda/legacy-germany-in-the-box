# storage system for navigation history
class NavigationHistory
  class Store
    MAX_HISTORY = 10.freeze
    # will exclude those paths from the history store. the system is based on implicit wildcard
    # the less precise you are in the paths, the more path and subpath it excludes
    # /connect also means everything inside /connect/ such as /connect/sign_in, etc.
    EXCLUDED_PATHS = %w(/connect).freeze

    attr_reader :request, :session, :location, :repository

    def initialize(request, session, repository, location)
      @request = request
      @session = session
      @repository = repository
      @location = solve(location)
    end

    def add(option = nil)
      return false unless acceptable_request?
      return false if excluded_path?

      prepare_storage

      # force add a session and force the last entered URL
      if option == :force
        session[:force_url] = location_path
      else
        # normal process without force URL
        add_storage
        trim_storage
      end

      session['previous_urls'][repository]
    end

    private

      # will solve keys such as `:current`
      # this will be used in case of server error for instance
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
            if uri_location.query.present?
              "#{uri_location.path}?#{uri_location.query}"
            else
              "#{uri_location.path}"
            end
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

      # if location path returns nil it's not acceptable
      def acceptable_request?
        location_path
      end

      def already_last_stored?
        session['previous_urls'][repository].first == location_path
      end

      def prepare_storage
        legacy_conversion!
        session['previous_urls'] ||= {}
        session['previous_urls'][repository] ||= []
      end

      def add_storage
        unless already_last_stored?
          session['previous_urls'][repository].unshift(location_path)
        end
      end

      def trim_storage
        if session['previous_urls'][repository].size > MAX_HISTORY
          session['previous_urls'][repository].pop
        end
      end

      # TODO : this will be removed after a few days
      # - Laurent, 13th December 2016
      def legacy_conversion!
        if session['previous_urls'].instance_of? Array
          session['previous_urls'] = nil
        end
      end
  end
end
