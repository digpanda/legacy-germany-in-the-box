class WechatApi::Messenger < BaseService
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
        if wechat_api_media.data
          wechat_api_media.data[:media_id]
        end
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
          UrlToPath.new(content[:url]).perform
        end
      end

      def wechat_api_media
        @wechat_api_media ||= WechatApi::Media.new(type: :image, target: target).resolve
      end
  end
end
