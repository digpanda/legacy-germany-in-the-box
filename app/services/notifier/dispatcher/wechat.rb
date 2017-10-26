# send a wechat message from our service from the notifier dispatcher
# this won't work if the user does not comes from wechat
class Notifier
  class Dispatcher
    class Wechat
      attr_reader :dispatcher

      def initialize(dispatcher)
        @dispatcher = dispatcher
      end

      def perform
        if sendable?
          messenger.text! dispatcher.desc
        end
      end

      private

        def messenger
          @messenger ||= WechatApiMessenger.new(openid: dispatcher.user.wechat_openid)
        end

        def sendable?
          dispatcher.user&.wechat_openid
        end

    end
  end
end
