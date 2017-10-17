class WechatApiMessenger < BaseService
  attr_reader :openid, :content, :type

  SOURCE = 'https://api.weixin.qq.com'.freeze
  # SOURCE = 'https://api.wechat.com'.freeze

  # type can be :text, :image
  def initialize(openid:, type: :text)
    @openid = openid
    @type = type
  end

  def send(content)
    # we set it here because it's way more convenient at a structure level
    # but we should turn that into a subclass if we send more than simple contents
    @content = content
    # now we make the different API calls
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
      case type
      when :text
      {
        'touser': openid,
        'msgtype': 'text',
        'text':
        {
          'content': content
        }
      }
      when :image
        {
          "touser": openid,
          "msgtype": 'image',
          "image":
          {
            "media_id": media_id
          }
        }
      end
    end

    def media_id
      wechat_api_media.data[:media_id]
    end

    def media_path
      "#{Rails.root}/public/images/services-cover.jpg"
    end

    def wechat_api_media
      @wechat_api_media ||= WechatApiMedia.new(type: type, path: media_path).resolve
    end

    def access_token_gateway
      @access_token_gateway ||= WeixinApiAccessToken.new.resolve
    end

    def access_token
      access_token_gateway.data[:access_token]
    end
end
