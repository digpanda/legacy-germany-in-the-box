module SmartExchange
  module Scheme
    class Offers < Base

      # valid_until -> { 7.days.from_now }

      def request
        '优惠券'
      end

      def response
        messenger.text! data(:offers)
      end
    end
  end
end
