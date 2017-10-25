class WechatApiSemantic < BaseService
  attr_reader :user, :query

  def initialize(user, query)
    @user = user
    @query = query
  end

  def resolve
    return return_with(:error, access_token_gateway.error) unless access_token_gateway.success?
    SlackDispatcher.new.message("SEMANTIC GATEWAY : #{semantic_gateway}")
    return return_with(:error, semantic_gateway['errmsg']) unless success?
    SlackDispatcher.new.message("SEMANTIC RESULT : #{semantic_gateway}")
    return_with(:success, semantic: semantic_gateway)
  end

  private

    def success?
      !semantic_gateway['errcode'] || (semantic_gateway['errcode'] == 0)
    end

    def semantic_gateway
      @semantic_gateway ||= Parser.post_json url, body
    end

    def url
      "https://api.weixin.qq.com/semantic/semproxy/search?access_token=#{access_token}"
    end

    def body
      {
        query: query,
        city: city,
        category: category,
        appid: appid,
        uid: uid
      }
    end

    def appid
      ENV['wechat_username_mobile']
    end

    def uid
      user.wechat_openid
    end

    # TODO : to be made dynamic
    def category
      "flight, hotel"
    end

    def city
      "Beijing"
    end

    def access_token_gateway
      @access_token_gateway ||= WeixinApiAccessToken.new.resolve
    end

    def access_token
      access_token_gateway.data[:access_token]
    end
end