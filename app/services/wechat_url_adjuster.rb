# the purpose of this small library
# is to turn any URL into a valid wechat one
# anyone who clicks on this link through wechat
# will go through their service and be logged-in
# while accessing the target URL
class WechatUrlAdjuster < BaseService
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def adjusted_url
    end_url
  end

  private

    def end_url
      "#{service_url}?appid=#{appid}&redirect_uri=#{encoded_url}&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect"
    end

    # force escape everything, included URL specific characters
    def encoded_url
      CGI.escape(url)
    end

    def service_url
      'https://open.weixin.qq.com/connect/oauth2/authorize'
    end

    def appid
      ENV['wechat_username_mobile']
    end
end
