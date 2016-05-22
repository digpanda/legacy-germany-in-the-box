require_relative 'base'

module BorderGuru
  module Requests
    class ShippingApi < Base

      def dispatch!
        @raw_response = @@access_token.post(
          "/api/shipping?quoteParams=#{quote_params}",
          nil,
          "Content-Type" => 'application/x-www-form-urlencoded'
        )
        nil
      end


    end
  end
end
