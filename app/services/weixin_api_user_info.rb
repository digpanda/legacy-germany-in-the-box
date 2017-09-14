class WeixinApiUserInfo < BaseService
  attr_reader :openid

  def initialize(openid)
    @openid = openid
  end

  def resolve!
    return return_with(:error, access_token_gateway.error) unless access_token_gateway.success?
    return return_with(:error, user_info_gateway['errmsg']) if user_info_gateway['errcode']
    return_with(:success, user_info: user_info_gateway)
  end

  private

  def user_info_gateway
    @user_info_gateway ||= Parser.get_json user_info_url
  end

  def user_info_url
    "https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{access_token}&openid=#{openid}"
  end

  def access_token_gateway
    @access_token_gateway ||= WeixinApiAccessToken.new.resolve!
  end

  def access_token
    access_token_gateway.data[:access_token]
  end

end
