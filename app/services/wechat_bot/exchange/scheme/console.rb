class WechatBot
  class Exchange < WechatBot::Base
    class Scheme < WechatBot::Exchange
      class Console < Scheme
        def request
          'console'
        end

        def response
          messenger.text! "Console activated for #{user.full_name}"
        end
      end
    end
  end
end
