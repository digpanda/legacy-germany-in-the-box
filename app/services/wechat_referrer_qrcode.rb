class WechatReferrerQrCode < BaseService

  attr_reader :code

  def initialize(code)
    @code = code
  end

  def resolve!
    if qrcode.success?
      return_with(:success, customer: qrcode.data[:qrcode])
    else
      return_with(:error, error: connect_user.error)
    end
  end

  # we try to the referrer qrcode in 3 steps
  def qrcode
    @qrcode ||= begin
      binding.pry
    end
  end

  private

  def access_token_gateway
    @access_token_gateway ||= get_url weixin_access_token_url
  end

  def weixin_access_token_url
    "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{Rails.application.config.wechat[:username_mobile]}&secret=#{Rails.application.config.wechat[:password_mobile]}"
  end

  def get_url(url)
    response = Net::HTTP.get(URI.parse(url))
    JSON.parse(response)
  end

end
