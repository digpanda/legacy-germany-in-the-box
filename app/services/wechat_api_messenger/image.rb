class WechatApiMessenger < BaseService
  class Image < Base

    private

      def body
        {
          "touser": openid,
          "msgtype": 'image',
          "image":
          {
            "media_id": media_id
          }
        }
      end

      def media_id
        wechat_api_media.data[:media_id]
      end

      def media_path
        if content[:path]
          "#{Rails.root}/public#{content[:path]}"
        elsif content[:url]
          content[:url]
        end
      end

      def wechat_api_media
        @wechat_api_media ||= WechatApiMedia.new(type: :image, path: media_path).resolve
      end
  end
end
