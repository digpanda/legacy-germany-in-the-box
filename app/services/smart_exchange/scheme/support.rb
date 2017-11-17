module SmartExchange
  module Scheme
    class Support < Base

      # valid_until -> { 7.days.from_now }

      def request
        '客服'
      end

      def response
        messenger.text! data(:support)
        messenger.image! path: '/images/wechat/wechat_support_qr.jpg'
      end
    end
  end
end
