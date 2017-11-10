module WechatBot
  module Exchange
    module Helpers

      def slack
        @slack ||= SlackDispatcher.new
      end

      def messenger
        @messenger ||= WechatApiMessenger.new(openid: user.wechat_openid)
      end

      # will parse any file within `data/*.txt` and return its interpreted string
      # very useful for templating desired responses from the Wechat Bot
      def data(file, params = {})
        Parser.render_template file: File.join(File.dirname(__FILE__), "../data/#{file}.txt"),
                               params: params
      end
    end
  end
end