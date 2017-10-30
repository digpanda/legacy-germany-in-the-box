class WechatBot
  class Exchange < Base
    class Base < Exchange
      # NOTE : we inherit exchange because it's actually very convenient
      # it contains everything like slack, messenger, data, etc.
      def request
      end

      def response
      end
    end
  end
end
