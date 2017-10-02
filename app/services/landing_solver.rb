# when a user first reach our site
# he will set on different area as home
# wechat users are typically going to services and package sets
# the others go to the home page with products
class LandingSolver < BaseService
  include Rails.application.routes.url_helpers

  attr_reader :request, :session, :params

  # keep it in string since it's compared to stringified params
  ALLOWED_FORCE_LANDING = ['package_sets', 'products'].freeze

  def initialize(request)
    @request = request
    @session = request.session
    @params = request.params
  end

  def setup!
    force_landing!
    return self unless just_landed?
    solve_landing!
    self
  end

  # double logic for now in case it's a wrong variable
  def recover
    case session[:landing]
    when :package_sets
      guest_package_sets_path
    when :products
      root_path
    else
      root_path
    end
  end

  private

    def services_path?
      request.url.include? guest_services_path
    end

    def package_sets_path?
      request.url.include? guest_package_sets_path
    end

    def from_wechat?
      session[:origin] == :wechat
    end

    def just_landed?
      return false if session[:landing]
      true
    end

    # if it matches with services or package sets path it's automatically defined
    # if the user comes from wechat, the default landing is package sets area
    def solve_landing!
      if services_path? || package_sets_path? || from_wechat?
        session[:landing] = :package_sets
      else
        session[:landing] = :products
      end
    end

    def force_landing!
      if params[:landing]
        if ALLOWED_FORCE_LANDING.include? params[:landing]
          session[:landing] = params[:landing].to_sym
        end
      end
    end
end
