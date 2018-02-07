class WechatApiMessenger < BaseService
  class Base < WechatApiMessenger
    SOURCE = 'https://api.weixin.qq.com'.freeze

    attr_reader :openid, :content

    def initialize(messenger, content)
      @openid = messenger.openid
      @content = content
    end

    def send
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

      def access_token_gateway
        @access_token_gateway ||= WechatApiAccessToken.new.resolve
      end

      def access_token
        access_token_gateway.data[:access_token]
      end
  end
end
