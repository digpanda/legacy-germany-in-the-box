class WechatApiMessenger < BaseService
  class Rich < Base
    attr_reader :articles

    # specific initialize (not like text and image)
    def initialize(messenger)
      @openid = messenger.openid
      @articles = []
    end

    def add(title:, description:, url:, picture_url:)
      @articles << {
        title: title,
        description: description,
        url: url,
        picurl: picture_url
      }
      self
    end

    private

      def body
        {
           "touser": openid,
           "msgtype": "news",
           "news":{
               "articles": articles
           }
        }
      end
  end
end
