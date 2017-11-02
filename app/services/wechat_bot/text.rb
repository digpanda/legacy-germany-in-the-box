class WechatBot
  class Text < Base
    attr_reader :user, :content

    CUSTOMER_SUPPORT_CHANNEL = '#customer_support'

    def initialize(user, content)
      @user = user
      @content = content
    end

    def dispatch
      SlackDispatcher.new.message("DISPATCHING SERVICE")
      # if the exchange is recognized and successful
      # we don't need to dispatch the rest
      unless exchange.perform
        # we dispatch it to a specific slack channel
        # dedicated to the customer support
        slack_support.service_message(user, content)
        notify_admin
      end

      return_with(:success)
    end

    private

      def exchange
        @exchange ||= WechatBot::Exchange.new(user, content)
      end

      def slack_support
        @slack_support ||= SlackDispatcher.new(custom_channel: CUSTOMER_SUPPORT_CHANNEL)
      end

      def notify_admin
        Notifier::Admin.new.new_wechat_message(user, content)
      end
  end
end
