class WechatBot
  class Exchange < Base
    class Base
      attr_reader :user, :request

      def initialize(user, request)
        @user = user
        @request = request
      end

      def request
      end

      def response
      end
    end
  end
end
