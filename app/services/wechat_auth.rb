class WechatAuth < BaseService

  attr_reader :code

  def initialize(code, token)
    @code = code
    @token = token
  end

  def resolve!
    if valid_user?
      return_with(:success, customer: @user)
    else
      return_with(:error)
    end
  end

  def valid_user?
    parsed_response = get_access_token(code)
    openid = parsed_response['openid']
    unionid = parsed_response['unionid']

    return false if parsed_response['errcode']

    @user = User.where(provider: 'wechat', wechat_unionid: unionid).first

    if @user
      sign_in_user(@user)
    else
      access_token = parsed_response['access_token']
      @parsed_response = get_user_info(access_token, openid)

      return false if parsed_response['errcode']

      auth_user
    end

    true
  end

  private

  def wechat_silent_solver
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
      @user = wechat_silent_solver.data[:customer]
      @user.assign_referrer_id if ReferrerToken.valid_token?(token)
      sign_in_user(@user)
    end
  end

  def sign_in_user(user)
    sign_out
    sign_in(:user, user)
  end
end