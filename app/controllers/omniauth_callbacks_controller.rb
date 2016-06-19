class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  #skip CSRF on create.
  skip_before_filter :verify_authenticity_token

  def all
    user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect user, success: 'success'
  end

  alias_method :wechat, :all
end
