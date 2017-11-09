# when someone triggers the menu on wechat service
# it will go down here to send a callback
module WechatBot
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
          messenger.text! '2017a'
        when 'groupchat'
          messenger.image! path: '/images/wechat/group.jpg'
        when 'chatsale'
          messenger.text! data(:chatsale)
          messenger.image! path: '/images/wechat/wechat_support_qr.jpg'
        when 'support'
          messenger.text! data(:support)
          messenger.image! path: '/images/wechat/wechat_support_qr.jpg'
        when 'ping'
          messenger.text! data(:ping)
        end

        return_with(:success)
      end

    end
  end
end
