class WechatBot
  class Exchange < WechatBot::Base
    class Offers < Scheme
      # test system to see if the whole structure works fine
      def request
        'offers'
      end

      def response
        messenger.text! data(:offers)
      end
    end
  end
end
