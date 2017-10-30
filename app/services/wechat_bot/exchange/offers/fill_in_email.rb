class WechatBot
  class Exchange < WechatBot::Base
    class Offers < Exchange::Base
      class FillInEmail < Exchange::Base
        def request
          '1'
        end

        def response
          messenger.text! 'Please enter your email'
        end
      end
    end
  end
end
