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
        SlackDispatcher.new.message("MEDIA DISPATCHER #{wechat_api_media}")
        wechat_api_media.data[:media_id]
      end

      # for now there's no differenciation
      # at this level but we keep the split anyhow
      def target
        if content[:path]
          "#{Rails.root}/public#{content[:path]}"
        elsif content[:url]
          content[:url]
        end
      end

      def wechat_api_media
        @wechat_api_media ||= WechatApiMedia.new(type: :image, target: target).resolve
      end
  end
end
