class Api::ApplicationController < ApplicationController

  # Should be slightly refactored and put into libraries ?
  def throw_resource_not_found
    render status: :not_found,
           json: throw_error(:resource_not_found).to_json
  end

  def throw_unauthorized_page
    render status: :unauthorized,
           json: throw_error(:unauthorized_page).to_json
  end

end
