class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  #skip CSRF on create.
  skip_before_filter :verify_authenticity_token
  load_and_authorize_resource :except => [:wechat, :failure]

  def wechat
    flash[:success] = I18n.t(:wechat_login, scope: :notice)
    user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in(:user, user)
    redirect_to after_sign_in_path_for(user)
  end

  def failure
    flash[:error] = I18n.t(:wechat_login_fail, scope: :notice)
    redirect_to(:back)
    return
  end

end
