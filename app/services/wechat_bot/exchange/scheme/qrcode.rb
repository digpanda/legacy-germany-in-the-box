module WechatBot
  module Exchange
    module Scheme
      class Qrcode < Base
        extend Options

        def request
          if user&.referrer
            '二维码'
          else
            false
          end
        end

        def response
          messenger.image! url: "#{guest_referrer_qrcode_url(user.referrer)}.jpg"
        end
      end
    end
  end
end
