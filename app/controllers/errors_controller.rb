class ErrorsController < ActionController::Base
  # this is a very specific controller
  # it doesn't inherit from the ApplicationController because it's a standalone controller
  # we manage the `deep` errors here, showing a JSON answer if we are within the API area
  # or showing the error page if we aren't.
  # this level is initialized directly from the router therefore those output
  # will be generated before the `application_controller`
  # error management (resource not found, etc.)
  before_action :identity_solver

  include ErrorsHelper
  layout "errors/default"

  def page_not_found
    if api?
      render status: :not_found,
             json: throw_error(:page_not_found).to_json
    end
  end

  def server_error
    if api?
      render status: :internal_server_error,
             json: throw_error(:server_error).to_json
    end
  end

  def unauthorized_page
    if api?
      render status: :unauthorized,
             json: throw_error(:unauthorized_page).to_json
    end
  end

  private

    def identity_solver
      @identity_solver ||= IdentitySolver.new(request, current_user)
    end

    def api?
      (env["REQUEST_URI"] =~ /^\/api/) == 0
    end
end
