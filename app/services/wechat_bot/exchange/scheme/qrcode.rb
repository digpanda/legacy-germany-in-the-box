class WechatBot
  class Exchange < WechatBot::Base
    class Scheme < WechatBot::Exchange
      class Qrcode < Scheme
        def request
          if user&.referrer
            '二维码'
          end
        end

        def response
          messenger.image! url: "#{guest_referrer_qrcode_url(user.referrer)}.jpg"
        end
      end
    end
  end
end
