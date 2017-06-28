class Connect::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # skip CSRF on create.
  skip_before_filter :verify_authenticity_token
  skip_before_action :silent_login
  skip_before_action :get_cart_orders

  # QRCode Wechat classic login system
  def wechat
    if wechat_solver.success?
      sign_in_user(wechat_solver.data[:customer])
    else
      failure
    end
  end

  # QRCode Wecaht tour guide registration
  def referrer
    if params[:code] && params[:token]
      # wechat auth is taken from application controller
      if wechat_auth.success?
        user = wechat_auth.data[:customer]

        if ReferrerToken.valid_token?(params[:token])

          Referrer.create(user: user) unless user.referrer
          user.reload
          user.referrer.update(referrer_token_id: ReferrerToken.where(token: params[:token]).first.id)

          Coupon.create_referrer_coupon(user.referrer) if user.referrer.coupons.empty?
        end

        sign_out
        sign_in(:user, user)
        session[:landing] = :package_sets
        SlackDispatcher.new.silent_login_attempt("[Wechat] Tourist guide automatically logged-in (`#{user&.id}`)")
        redirect_to customer_referrer_path
        return

      end
    end
    redirect_to root_path
  end

  def failure
    flash[:error] = I18n.t(:wechat_login_fail, scope: :notice)
    redirect_to navigation.back(1)
  end

  private

  def wechat_solver
    @wechat_solver ||= WechatConnectSolver.new(wechat_data).resolve!
  end

  def wechat_data
    {
      provider: request.env["omniauth.auth"].provider,
      unionid: request.env["omniauth.auth"].info.unionid,
      openid: request.env["omniauth.auth"].info.openid,
      nickname: request.env["omniauth.auth"].info.nickname,
      avatar: request.env["omniauth.auth"].info.headimgurl,
      sex: request.env["omniauth.auth"].info.sex,
    }
  end

  def sign_in_user(user)
    flash[:success] = I18n.t(:wechat_login, scope: :notice)
    sign_in(:user, user)
    redirect_to after_sign_in_path_for(user)
  end

end
