class WechatApiUserInfo < BaseService

  attr_reader :openid

  def initialize(openid)
    @openid = openid
  end

  def resolve!
    return return_with(:error, "Access token is wrong") if access_token_gateway['errcode']
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
    "https://api.weixin.qq.com/cgi-bin/user/access_token?appid=#{Rails.application.config.wechat[:username_mobile]}&secret=#{Rails.application.config.wechat[:password_mobile]}&grant_type=authorization_code"
  end

  def user_info_url
    "https://api.weixin.qq.com/cgi-bin/user/info?ccess_token=#{access_token}&openid=#{openid}"
  end

  def get_url(url)
    response = Net::HTTP.get(URI.parse(url))
    JSON.parse(response)
  end

end
