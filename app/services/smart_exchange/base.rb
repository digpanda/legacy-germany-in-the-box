module SmartExchange
  class Base
    extend SmartExchange::Utils::Options
    include SmartExchange::Utils::Helpers
    include Rails.application.routes.url_helpers

    attr_reader :user, :request

    def initialize(user, request)
      @user = user
      @request = request.downcase.strip
    end
  end
end
