class WechatBot
  class Exchange < WechatBot::Base
    class Qrcode < Base
      def request
        '二维码'
      end

      # this is not the best way at a performance level because it accepts #request and then cancel it via a false if the user is not referrer
      # best is to control this from the #request itself and return nil. The result is the same tho.
      # WE KEPT THIS AS A GOOD EXAMPLE
      def response
        if user&.referrer
          # wechat forces us to use '.jpg' extension otherwise it considers the file as invalid format
          # NOTE : yes, they don't check MIME Type, no clue why.
          messenger.image! url: "#{guest_referrer_qrcode_url(user.referrer)}.jpg"
          return true
        end
        false
      end
    end
  end
end
