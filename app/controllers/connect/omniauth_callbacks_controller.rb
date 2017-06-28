class Connect::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # skip CSRF on create.
  skip_before_filter :verify_authenticity_token
  skip_before_action :silent_login
  skip_before_action :get_cart_orders

  def wechat
    if wechat_solver.success?
      sign_in_user(wechat_solver.data[:customer])
    else
      failure
    end
  end

  def referrer
    if params[:code]
      if wechat_auth.success?
        user = wechat_auth.data[:customer]
        @tourist_guide = true

        if ReferrerToken.valid_token?(params[:token])
          unless user.referrer
            Referrer.create(user: user)
          end

          user.reload

          user.referrer.update(referrer_token_id: ReferrerToken.where(token: params[:token]).first.id)
          Coupon.create_referrer_coupon(user.referrer) if user.referrer.coupons.empty?
        end

        sign_out
        sign_in(:user, user)
        session[:landing] = :package_sets
        SlackDispatcher.new.silent_login_attempt("[Wechat] Tourist guide automatically logged-in (`#{user&.id}`)")

        if @tourist_guide
          redirect_to customer_referrer_path
          return
        end
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
    SlackDispatcher.new.message("OMNIAUTH CALLBACK -> WECHAT SOLVER -> #{request.env["omniauth.auth"]}")
    @wechat_solver ||= WechatConnectSolver.new(request.env["omniauth.auth"]).resolve!
  end

  def wechat_silent_solver
    SlackDispatcher.new.message("OMNIAUTH CALLBACK -> WECHAT SILENT SOLVER -> #{@parsed_response}")
    @wechat_solver ||= WechatSilentConnectSolver.new(@parsed_response).resolve!
  end

  def get_access_token(code)
    url = "https://api.wechat.com/sns/oauth2/access_token?appid=#{Rails.application.config.wechat[:username_mobile]}&secret=#{Rails.application.config.wechat[:password_mobile]}&code=#{code}&grant_type=authorization_code"
    get_url(url)
  end

  def get_user_info(access_token, openid)
    url = "https://api.wechat.com/sns/userinfo?access_token=#{access_token}&openid=#{openid}"
    get_url(url)
  end

  def get_url(url)
    response = Net::HTTP.get(URI.parse(url))
    JSON.parse(response)
  end

  def auth_user
    if wechat_silent_solver.success?
      sign_in_user(wechat_silent_solver.data[:customer])
    else
      flash[:error] = I18n.t(:wechat_login_fail, scope: :notice)
      redirect_to root_path
    end
  end

  def sign_in_user(user)
    flash[:success] = I18n.t(:wechat_login, scope: :notice)
    sign_in(:user, user)
    redirect_to after_sign_in_path_for(user)
  end

end
