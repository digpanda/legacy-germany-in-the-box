class Api::SessionsController < SessionsController

  before_action :authenticate_user!, except: [:set_redirect_location, :is_auth]

  def set_redirect_location
    session[:previous_url] = params["location"] unless params["location"].nil?
    render json: {success: true} and return # should be improved
  end

  def is_auth
    render json: {success: true, is_auth: !current_user.nil?}
  end

end