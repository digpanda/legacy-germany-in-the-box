module WechatBot
  module Exchange
    module Scheme
      class Ping < Base

        valid_until -> { 1.days.from_now }

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
