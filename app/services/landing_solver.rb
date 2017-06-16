class LandingSolver

  include Rails.application.routes.url_helpers

  attr_reader :request, :session, :params

  # keep it in string since it's compared to stringified params
  ALLOWED_FORCE_LANDING = ["package_sets", "products"]

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

  def just_landed?
    return false if session[:landing]
    true
  end

  def solve_landing!
    if request.url.include? guest_package_sets_path
      session[:landing] = :package_sets
    else
      session[:landing] = :products
    end
  end

  def force_landing!
    if params[:landing]
      SlackDispatcher.new.message("LANDING PARAM IS `#{params[:landing]}`")
      if ALLOWED_FORCE_LANDING.include? params[:landing]
        session[:landing] = params[:landing].to_sym
      end
    end
  end

end
