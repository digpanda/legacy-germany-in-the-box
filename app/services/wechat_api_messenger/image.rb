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

      # for now there's no differenciation
      # at this level but we keep the split anyhow
      def target
        if content[:path]
          "#{Rails.root}/public#{content[:path]}"
        elsif content[:url]
          # wechat does not accept temporary files or URLs so we made a homemade library
          # to save the image into a directory and output it directly
          # this library will output the path directly
          SlackDispatcher.new.message("ORIGINAL URL IS #{content[:url]}")
          path = UrlToPath.new(content[:url]).perform
          SlackDispatcher.new.message("PATH IS #{path}")
          path
        end
      end

      def wechat_api_media
        @wechat_api_media ||= WechatApiMedia.new(type: :image, target: target).resolve
      end
  end
end
