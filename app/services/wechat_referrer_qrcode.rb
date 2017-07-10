class WechatReferrerQrcode < BaseService

  attr_reader :referrer

  def initialize(referrer)
    @referrer = referrer
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
      return return_with(:error, "Access token is wrong") if access_token_gateway['errcode']

    end
  end

  private

  def access_token
    access_token_gateway['access_token']
  end

  def access_ticket
    @access_ticket ||= begin
      # POST ticket_url with body
      # {
      #     "expire_seconds": 604800,
      #     "action_name": "QR_STR_SCENE",
      #     "action_info": {
      #         "scene": {
      #             "scene_str": "test"
      #         }
      #     }
      # }
    end
  end

  def access_token_gateway
    @access_token_gateway ||= get_url weixin_access_token_url
  end

  def ticket_url
    "https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=#{access_token}"
  end

  def weixin_access_token_url
    "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{Rails.application.config.wechat[:username_mobile]}&secret=#{Rails.application.config.wechat[:password_mobile]}"
  end

  def get_url(url)
    response = Net::HTTP.get(URI.parse(url))
    JSON.parse(response)
  end

end
