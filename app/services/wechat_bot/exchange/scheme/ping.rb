class WechatBot
  class Exchange < WechatBot::Base
    class Scheme < WechatBot::Exchange
      class Ping < Scheme
        extend Options
        
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
end
