class WechatApi::Messenger < BaseService
  class Text < Base

    private

      def body
        {
          'touser': openid,
          'msgtype': 'text',
          'text':
          {
            'content': content
          }
        }
      end
  end
end
