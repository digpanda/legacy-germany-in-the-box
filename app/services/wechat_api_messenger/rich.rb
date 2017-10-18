class WechatApiMessenger < BaseService
  class Rich < Base

    attr_reader :articles

    def initialize
      super
      @articles = []
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

      def add(title:, description:, url:, picture_url:)
        @articles << {
          title: title,
          description: description,
          url: url,
          picurl: picture_url
        }
      end

  end
end
