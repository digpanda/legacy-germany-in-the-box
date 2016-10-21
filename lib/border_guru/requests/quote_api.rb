require_relative 'base'

module BorderGuru
  module Requests
    class QuoteApi < Base

      def dispatch!
        SlackDispatcher.new.message("/api/quotes/calculate?quoteParams=#{quote_params}")
        @raw_response = @@access_token.post(
          "/api/quotes/calculate?quoteParams=#{quote_params}",
          nil,
          "Content-Type" => 'application/x-www-form-urlencoded'
        )
        nil
      end

    end
  end
end
