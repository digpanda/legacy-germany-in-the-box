class WeixinApiAccessToken < BaseService
  attr_reader :appid, :secret

  def initialize(appid:nil, secret:nil)
    @appid = appid || Rails.application.config.wechat[:username_mobile]
    @secret = secret || Rails.application.config.wechat[:password_mobile]
  end

  def resolve!
    return return_with(:error, gateway['errmsg']) unless success?
    return_with(:success, access_token: access_token)
  end

  def access_token
    gateway['access_token']
  end

  private

  def success?
    !gateway['errcode'] || (gateway['errcode'] == 0)
  end

  def gateway
    @gateway ||= get_url url
  end

  def url
    "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{appid}&secret=#{secret}"
  end

  def get_url(url)
    response = Net::HTTP.get(URI.parse(url))
    JSON.parse(response)
  end
end
