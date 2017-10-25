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
          messenger.text(data(:chatsale)).send
          messenger.image(path: '/images/wechat/wechat_support_qr.jpg').send
        when 'support'
          messenger.text(data(:support)).send
          messenger.image(path: '/images/wechat/wechat_support_qr.jpg').send
        when 'ping'
          messenger.text(data(:ping)).send
        end

        return_with(:success)
      end

    end
  end
end
