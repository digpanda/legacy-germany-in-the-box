class Connect::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  #skip CSRF on create.
  skip_before_filter :verify_authenticity_token
  load_and_authorize_resource :except => [:wechat, :failure]

  def wechat
    flash[:success] = I18n.t(:wechat_login, scope: :notice)
    user = user_from_omniauth(request.env["omniauth.auth"])
    user.reload
    sign_in(:user, user)
    redirect_to after_sign_in_path_for(user)
  end

  def failure
    flash[:error] = I18n.t(:wechat_login_fail, scope: :notice)
    redirect_to(:back)
    return
  end

  def user_from_omniauth(auth)
    if User.where(provider: auth.provider, uid: auth.uid).first
      User.where(provider: auth.provider, uid: auth.uid).first
    else
      User.new.tap do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = "#{auth.info.unionid}@wechat.com"
        user.username = auth.info.nickname
        user.role = :customer
        user.gender = auth.info.sex == 1 ? 'm' : 'f'
        user.birth = Date.today # what the fuck ? is that normal ? - Laurent 04/08/2016
        user.password = auth.info.unionid[0,8]
        user.password_confirmation = auth.info.unionid[0,8]
        user.wechat_unionid = auth.info.unionid
        user.save
      end
    end
  end

end
