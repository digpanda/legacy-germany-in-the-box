# when someone triggers the menu on wechat service
# it will go down here to send a callback
class WechatBot
  class Event < Base
    class Click < Base
      attr_reader :user, :event_key

      def initialize(user, event_key)
        @user = user
        @event_key = event_key
      end

      # menu click handling here
      def handle
        case event_key
        when 'offers'
          messenger.text('2017a').send
        when 'groupchat'
          messenger.image(path: '/images/wechat/group.jpg').send
        when 'chatsale'
          messenger.text("""
  欢迎您通过微信客服聊天直接下单或者询问相关事宜。\n
  请扫来因盒微信号下面二维码或添加来因盒微信号:germanbox 也可以点击左下角小键盘直接留言。\n
  """).send
          messenger.image(path: '/images/wechat/wechat_support_qr.jpg').send
        when 'support'
          messenger.text("""
  欢迎您通过微信客服联系下单及其他业务事宜。\n
  请扫来因盒微信号下面二维码或添加来因盒微信号:germanbox 也可以点击左下角小键盘直接留言。\n
  📧客服邮箱: customer@germanyinthebox.com\n
  📞客服电话: 49-(0)89-21934711, 49-(0)89-21934727\n
  """).send
          messenger.image(path: '/images/wechat/wechat_support_qr.jpg').send
        when 'ping'
          messenger.text('pong').send
        end

        return_with(:success)
      end

    end
  end
end
