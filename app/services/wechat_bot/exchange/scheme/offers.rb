module WechatBot
  module Exchange
    module Scheme
      class Offers < Base

        valid_until -> { 7.days.from_now }

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
end
