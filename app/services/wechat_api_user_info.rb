class WechatApiUserInfo < BaseService

  attr_reader :openid

  def initialize(openid)
    @openid = openid
  end

  def resolve!
    return return_with(:error, "Access token is wrong") if access_token_gateway['errcode']
    SlackDispatcher.new.message("USER INFO GATEWAY : #{user_info_gateway}")
    return return_with(:error, "User info is wrong") if user_info_gateway['errcode']
    return_with(:success, user_info: user_info_gateway)
  end

  def access_token
    access_token_gateway['access_token']
  end

  private

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
    SlackDispatcher.new.message("ACCESS TOKEN : #{access_token}")
    SlackDispatcher.new.message("OPEN ID : #{openid}")
    "https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{access_token}&openid=#{openid}"
  end

  def get_url(url)
    response = Net::HTTP.get(URI.parse(url))
    JSON.parse(response)
  end

end
