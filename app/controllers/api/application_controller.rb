class Api::ApplicationController < ApplicationController
  # we skip all the normal base before_action because we are in API here
  skip_before_action :verify_authenticity_token, :force_wechat_login, :solve_silent_login, :solve_origin, :solve_landing

  def throw_resource_not_found
    render status: :not_found,
           json: throw_error(:resource_not_found).to_json
  end

  def throw_unauthorized_page
    render status: :unauthorized,
           json: throw_error(:unauthorized_page).to_json
  end

  def throw_server_error_page
    render status: :internal_server_error,
           json: throw_error(:server_error).to_json
  end
end
