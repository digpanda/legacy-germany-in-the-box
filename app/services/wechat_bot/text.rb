class WechatBot
  class Text < Base
    attr_reader :user, :content

    CUSTOMER_SUPPORT_CHANNEL = '#customer_support'

    def initialize(user, content)
      @user = user
      @content = content
    end

    def dispatch
      # we dispatch it to a specific slack channel
      # dedicated to the customer support
      slack_support.service_message(user, content)

      case content
      when 'ping'
        messenger.text(data(:ping)).send
      when 'semantic'
        WechatApiSemantic.new(user, "hello")
      when '二维码'
        if user&.referrer
          # wechat forces us to use '.jpg' extension otherwise it considers the file as invalid format
          # NOTE : yes, they don't check MIME Type, no clue why.
          messenger.image(url: "#{guest_referrer_qrcode_url(user.referrer)}.jpg").send
        end
      when 'offers'
        messenger.text(data(:offers)).send
      else
        Notifier::Admin.new.new_wechat_message(user, content)
      end

      return_with(:success)
    end

    private

      def slack_support
        @slack_support ||= SlackDispatcher.new(custom_channel: CUSTOMER_SUPPORT_CHANNEL)
      end

  end
end
