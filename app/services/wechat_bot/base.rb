class WechatBot
  class Base < BaseService
    include Rails.application.routes.url_helpers

    def slack
      @slack ||= SlackDispatcher.new
    end

    def messenger
      @messenger ||= WechatApiMessenger.new(openid: user.wechat_openid)
    end

    def data(file, params = {})
      Parser.render_template file: File.join(File.dirname(__FILE__), "data/#{file}.txt"),
                             params: params
    end

  end
end
