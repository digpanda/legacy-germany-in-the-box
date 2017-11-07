class WechatBot
  class Exchange < WechatBot::Base
    class Scheme < WechatBot::Exchange

      # it's the default valid
      VALID_UNTIL = -> { 5.hours.from_now }

      # NOTE : we inherit exchange because it's actually very convenient
      # it contains everything like slack, messenger, data, etc.
      # and add the base #request #response
      #
      # IMPORTANT
      # within any subclass, when you call @request it will be the actual text
      # the user sent, #request will be what is expected ; you can compare and play with it
      # WARNING : you have to control if you want to make the real request match here, not in #response
      def request
        false
      end

      # NOTE : even if #response return a false (boolean) it will consider the request completed
      # false in response = request completed and able to repeat itself (like a wrong format triggered so the user has to type again)
      # so if there's a problem with the resource model (usually user) you must reject the match in #request
      def response
      end
    end
  end
end
