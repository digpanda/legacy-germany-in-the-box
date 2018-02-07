class WechatApiMedia < BaseService
  attr_reader :type, :target

  def initialize(type: :image, target:)
    @type = type
    @target = target
  end

  def resolve
    return return_with(:error, access_token_gateway.error) unless access_token_gateway.success?
    return return_with(:error, media_gateway['errmsg']) unless success?
    return_with(:success, media_id: media_id)
  end

  private

    def success?
      !media_gateway['errcode'] || (media_gateway['errcode'] == 0)
    end

    def media_id
      media_gateway['media_id']
    end

    def media_gateway
      @media_gateway ||= Parser.post_media url, target
    end

    def url
      "http://file.api.wechat.com/cgi-bin/media/upload?access_token=#{access_token}&type=#{type}"
    end

    def access_token_gateway
      @access_token_gateway ||= WechatApiAccessToken.new.resolve
    end

    def access_token
      access_token_gateway.data[:access_token]
    end
end
