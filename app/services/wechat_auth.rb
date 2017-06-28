# NOTE : this is super disgusting library which was originally fine
# instance variables are going freestyle everywhere and it's absolutely not stable.
# it must be changed as soon as possible.
# - Laurent
class WechatAuth < BaseService

  attr_reader :code, :force_referrer

  def initialize(code, token, force_referrer=false)
    SlackDispatcher.new.message("WECHATAUTH IS CALLED")
    @code = code
    @token = token
    @force_referrer = force_referrer
  end

  def resolve!
    if valid_user?
      return_with(:success, customer: @user, tourist_guide: @tourist_guide)
    else
      return_with(:error)
    end
  end

  def valid_user?
    parsed_response = get_access_token(code)
    openid = parsed_response['openid']
    unionid = parsed_response['unionid']
    access_token = parsed_response['access_token']
    return false if parsed_response['errcode']

    @user = User.where(provider: 'wechat', wechat_unionid: unionid).first

    if @user
      update_user_info(access_token, openid)# unless @user.referrer_nickname
    else
      @parsed_response = get_user_info(access_token, openid)
      return false if @parsed_response['errcode']
      if wechat_silent_solver.success?
        @user = wechat_silent_solver.data[:customer]
        set_nickname(@parsed_response['nickname'])
      else
        return false
      end
    end

    true
  end

  private

  def wechat_silent_solver
    SlackDispatcher.new.message("WECHAT AUTH -> PARSED RESPONSE FOR SILENT CONNECT SOLVER -> #{@parsed_response}")
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
      if ReferrerToken.valid_token?(token) && force_referrer
        @user.assign_referrer_id
        @tourist_guide = true
      end

      sign_in_user(@user)
    end
  end

  def update_user_info(access_token, openid)
    parsed_response = get_user_info(access_token, openid)

    set_nickname(parsed_response['nickname'])
    @user.update(wechat_openid: parsed_response['openid'])
  end

  # TODO : this part is fucking disgusting and should be completely refactored.
  # - Laurent.
  def set_nickname(nickname)
    if !@user.referrer && force_referrer
      Referrer.create(user: @user)
    end
    if @user.referrer
      @user&.referrer.update(nickname: nickname)
    end
  end

  def sign_in_user(user)
    sign_out
    sign_in(:user, user)
  end
end
