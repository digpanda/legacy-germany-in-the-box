require 'open-uri'

class Connect::SessionsController < Devise::SessionsController

  def new
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  def destroy
    unless current_user
      redirect_to root_url
      return
    end
    reset_session
    redirect_to root_url
  end
end
