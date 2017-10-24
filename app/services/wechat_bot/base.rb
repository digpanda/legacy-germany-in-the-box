class WechatBot
  class Base < BaseService
    include Rails.application.routes.url_helpers

    def slack
      @slack ||= SlackDispatcher.new
    end

    def messenger
      @messenger ||= WechatApiMessenger.new(openid: user.wechat_openid)
    end
  end
end
