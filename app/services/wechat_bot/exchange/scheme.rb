class WechatBot
  class Exchange < WechatBot::Base
    class Scheme < WechatBot::Exchange

      # it's the default valid
      VALID_UNTIL = -> { 5.hours.from_now }

      # NOTE : we inherit exchange because it's actually very convenient
      # it contains everything like slack, messenger, data, etc.
      # and add the base #request #response
      # IMPORTANT
      # within any subclass, when you call @request it will be the actual text
      # the user sent, #request will be what is expected ; you can compare and play with it
      def request
        false
      end

      def response
        false
      end
    end
  end
end
