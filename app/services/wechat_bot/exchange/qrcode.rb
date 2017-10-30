class WechatBot
  class Exchange < Base
    class Qrcode < Base
      # semantic is a test text to make sure the semantic API works alright
      def request
        '二维码'
      end

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
