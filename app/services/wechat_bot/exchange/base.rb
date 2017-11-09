module WechatBot
  module Exchange
    class Base
      extend Exchange::Options
      include Exchange::Helpers
      include Rails.application.routes.url_helpers

      attr_reader :user, :request

      def initialize(user, request)
        @user = user
        @request = request.downcase.strip
      end
    end
  end
end
