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
        messenger.text('pong').send
      when '二维码'
        if user&.referrer
          # wechat forces us to use '.jpg' extension otherwise it considers the file as invalid format
          # NOTE : yes, they don't check MIME Type, no clue why.
          messenger.image(url: "#{guest_referrer_qrcode_url(user.referrer)}.jpg").send
        end
      when 'offers'
        messenger.text("""
      欢迎参加来因盒通关任务奖励🏆\n
      1.注册邮箱获取50元优惠券，请输入1\n
      2.向朋友推荐来因盒，每3位朋友完成注册获取80元优惠券，请输入2\n
      3.自己或每位推荐的朋友首次下单，获取100元优惠券，请输入3\n
      4.完成以上三个任务奖励，成为来因盒VIP会员，获取更多福利请输入4\n
      5.升级成为来因盒形象大使请输入5\n
      """).send
      else
        Notifier::Admin.new.new_wechat_message(user&.decorate&.who, content)
      end

      return_with(:success)
    end

    private

      def slack_support
        @slack_support ||= SlackDispatcher.new(custom_channel: CUSTOMER_SUPPORT_CHANNEL)
      end

  end
end
