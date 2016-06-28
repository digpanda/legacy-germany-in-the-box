class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  #skip CSRF on create.
  skip_before_filter :verify_authenticity_token
  load_and_authorize_resource :except => [:wechat, :failure]

  def wechat
    flash[:success] = "You successfully logged-in via WeChat."
    user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect user, success: 'success'
  end

  def failure
    flash[:error] = "We couldn't authenticate you via WeChat. Please try again."
    redirect_to(:back) and return
  end

end
