class WechatApiUserInfo < BaseService

  attr_reader :openid

  def initialize(openid)
    @openid = openid
  end

  def resolve!
    return return_with(:error, "Access token is wrong") if access_token_gateway['errcode']
    return return_with(:error, "User info is wrong") if user_info_gateway['errcode']
    ensure_menu!
    return_with(:success, user_info: user_info_gateway)
  end

  def access_token
    access_token_gateway['access_token']
  end

  private

  # NOTE : this is used for the wechat webhook to precreate user accounts
  # maybe we should move the logic in another library which we connect
  # on the webhook itself
  def ensure_menu!
    SlackDispatcher.new.message("MENU : #{menu_gateway}")
    menu_gateway
  end

  def menu_gateway
    @menu_gateway ||= get_url menu_url
  end

  def access_token_gateway
    @access_token_gateway ||= get_url access_token_url
  end

  def user_info_gateway
    @user_info_gateway ||= get_url user_info_url
  end

  def access_token_url
    "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{Rails.application.config.wechat[:username_mobile]}&secret=#{Rails.application.config.wechat[:password_mobile]}"
  end

  def user_info_url
    "https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{access_token}&openid=#{openid}"
  end

  def menu_url
    "https://api.weixin.qq.com/cgi-bin/get_current_selfmenu_info?access_token=#{access_token}"
  end

  def get_url(url)
    response = Net::HTTP.get(URI.parse(url))
    JSON.parse(response)
  end

end
