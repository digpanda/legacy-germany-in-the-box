class WechatBot
  class Exchange < Base
    class Ping < Base
      # test system to see if the whole structure works fine
      def request
        'ping'
      end

      def response
        messenger.text! data(:ping)
      end
    end
  end
end
