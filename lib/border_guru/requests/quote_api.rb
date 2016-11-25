require_relative 'base'
require 'api_cache'

module BorderGuru
  module Requests
    class QuoteApi < Base

      def dispatch!
        @raw_response = APICache.get(request_url, :fail => []) do
          api_call!
        end
        nil
      end

      def request_url
        @request_url ||= "/api/quotes/calculate?quoteParams=#{quote_params}"
      end

      def api_call!
        @@access_token.post(
          request_url,
          nil,
          "Content-Type" => 'application/x-www-form-urlencoded'
        )
      end

    end
  end
end
