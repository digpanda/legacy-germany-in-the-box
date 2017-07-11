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
      return return_with(:error, "Access ticket is wrong") if access_ticket_gateway['errcode']
      binding.pry
      return return_with(:error, "Access qrcode is wrong") if access_qrcode_gateway['errcode']
    end
  end

  # private

  def access_token
    access_token_gateway['access_token']
  end

  def access_ticket
    access_ticket_gateway['ticket']
  end

  def access_qrcode_gateway
    @access_qrcode_gateway ||= get_url qrcode_url
  end

  def access_ticket_gateway
    @access_ticket ||= begin
      post_url ticket_url, {
                "expire_seconds": 604800,
                "action_name": "QR_STR_SCENE",
                "action_info": {
                    "scene": {
                        "scene_str": "#{referrer.reference_id}"
                    }
                }
            }
    end
  end

  def access_token_gateway
    @access_token_gateway ||= get_url weixin_access_token_url
  end

  def qrcode_url
    "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=#{access_ticket}"
  end

  def ticket_url
    "https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=#{access_token}"
  end

  def weixin_access_token_url
    "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{Rails.application.config.wechat[:username_mobile]}&secret=#{Rails.application.config.wechat[:password_mobile]}"
  end

  def post_url(url, body)
    header = {'Content-Type': 'text/json'}
    uri = URI.parse(url)
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri, header)
    req.body = body.to_json
    res = https.request(req)
    JSON.parse(res.body)
  end

  def get_url(url)
    response = Net::HTTP.get(URI.parse(url))
    JSON.parse(response)
  end

end
