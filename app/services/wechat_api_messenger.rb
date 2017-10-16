class WechatApiMessenger < BaseService
  attr_reader :openid, :message

  SOURCE = 'https://api.weixin.qq.com'.freeze
  # SOURCE = 'https://api.wechat.com'.freeze

  def initialize(openid:)
    @openid = openid
  end

  def send(message)
    # we set it here because it's way more convenient at a structure level
    # but we should turn that into a subclass if we send more than simple messages
    @message = message
    return return_with(:error, access_token_gateway.error) unless access_token_gateway.success?
    return return_with(:error, gateway['errmsg']) if gateway['errcode']
    return_with(:success, gateway: gateway)
  end

  private

    def gateway
      @gateway ||= Parser.post_json url, body
    end

    def url
      "#{SOURCE}/cgi-bin/message/custom/send?access_token=#{access_token}"
    end

    def body
      {
        'touser': openid,
        'msgtype': 'text',
        'text':
        {
          'content': message
        }
      }
    end

    def access_token_gateway
      @access_token_gateway ||= WeixinApiAccessToken.new.resolve
    end

    def access_token
      access_token_gateway.data[:access_token]
    end
end
