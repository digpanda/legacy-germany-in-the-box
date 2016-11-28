class Connect::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # skip CSRF on create.
  skip_before_filter :verify_authenticity_token
  load_and_authorize_resource :except => [:wechat, :failure]

  def wechat
    flash[:success] = I18n.t(:wechat_login, scope: :notice)
    user = user_from_omniauth(request.env["omniauth.auth"])
    sign_in(:user, user)
    redirect_to after_sign_in_path_for(user)
  end

  def failure
    flash[:error] = I18n.t(:wechat_login_fail, scope: :notice)
    redirect_to(:back)
  end

  def user_from_omniauth(auth)
    existing_customer(auth) || new_customer(auth)
  end

  def existing_customer(auth)
    User.where(provider: auth.provider, uid: auth.uid).first
  end

  # TODO : improve the login and add the image of the user when it's the firs time he logs-in
  def new_customer(auth)
    User.create({
      :provider => auth.provider,
      :uid => auth.uid,
      :email => "#{auth.info.unionid}@wechat.com",
      :role => :customer,
      :gender => guess_sex(auth),
      :password => random_password,
      :password_confirmation => random_password,
      :wechat_unionid => auth.info.unionid # what is it for ?
    })
  end

  def guess_sex(auth)
     if auth.info.sex == 1
       'm'
     else
       'f'
     end
  end

  def random_password
    @random_password ||= SecureRandom.uuid
  end

end
