class WechatBot
  class Text < Base
    attr_reader :user, :content

    CUSTOMER_SUPPORT_CHANNEL = '#customer_support'

    def initialize(user, content)
      @user = user
      @content = content
    end

    def dispatch

      case content
      when 'ping'
        messenger.text! data(:ping)
      when 'semantic'
        # working clean : semantic
        WechatApiSemantic.new(user, "查一下明天从北京到上海的南航机票").resolve
      when '二维码'
        if user&.referrer
          # wechat forces us to use '.jpg' extension otherwise it considers the file as invalid format
          # NOTE : yes, they don't check MIME Type, no clue why.
          messenger.image! url: "#{guest_referrer_qrcode_url(user.referrer)}.jpg"
        end
      when 'offers'
        # TODO : THIS WOULD BE PUT IN MEMORY
        messenger.text! data(:offers)
        memory.insert(:five_tasks_challenge)
      else
        # TODO : TEST MEMORY
        u = User.first
        m = WechatBot::Text::Memory.new(u, 'test').perform
        # END OF TEST

        # THOUGHT :
        # RecursiveMemory.new("content").perform
        # -> answer with the correct answer or nil

        # this is the entry to complex exchange between user and bot
        # it check into the database if there's a breakpoint inserted
        # if so it processes it accordingly.
        return if memory.process_breakpoints
        # we dispatch it to a specific slack channel
        # dedicated to the customer support
        slack_support.service_message(user, content)
        Notifier::Admin.new.new_wechat_message(user, content)
      end

      return_with(:success)
    end

    private

      def memory
        @memory ||= WechatBot::Text::Memory.new(user, content)
      end

      def slack_support
        @slack_support ||= SlackDispatcher.new(custom_channel: CUSTOMER_SUPPORT_CHANNEL)
      end

  end
end
