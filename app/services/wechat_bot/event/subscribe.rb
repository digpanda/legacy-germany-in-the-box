# when someone just subscribes to our service channel
# this is called
module WechatBot
  class Event < Base
    class Subscribe < Base
      attr_reader :user

      def initialize(user)
        @user = user
      end

      # when the user subscribe it'll trigger this method
      def handle
        SlackDispatcher.new.message("WE WILL TRIGGER THE MESSAGE NOW")
        messenger.text! data(:subscribe, identity: user.decorate.readable_who)
      end
    end
  end
end
