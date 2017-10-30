class WechatBot
  class Exchange < WechatBot::Base
    class Base < WechatBot::Exchange
      # NOTE : we inherit exchange because it's actually very convenient
      # it contains everything like slack, messenger, data, etc.
      # and add the base #request #response
      # IMPORTANT
      # within any subclass, when you call @request it will be the actual text
      # the user sent, #request will be what is expected ; you can compare and play with it
      def request
      end

      def response
      end
    end
  end
end
