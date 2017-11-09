module WechatBot
  module Exchange
    class Base
      include Helpers
      extend Options
      
      attr_reader :user, :request

      def initialize(user, request)
        @user = user
        @request = request.downcase.strip
      end
    end
  end
end
