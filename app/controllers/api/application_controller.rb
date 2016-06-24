class Api::ApplicationController < ApplicationController

  rescue_from Mongoid::Errors::DocumentNotFound, :with => :throw_resource_not_found
  rescue_from CanCan::AccessDenied, :with => :throw_unauthorized_page

  def throw_resource_not_found
    render status: :not_found,
           json: throw_error(:resource_not_found).to_json and return
  end

  def throw_unauthorized_page
    render status: :unauthorized,
           json: throw_error(:unauthorized_page).to_json and return
  end

end