require_relative 'base'

module BorderGuru
  module Requests
    class TrackingApi < Base

      def dispatch!
        @raw_response = @@access_token.post(
          "/api/orders/event/#{CONFIG[:merchantIdentifier]}/#{merchant_order_id}?#{payload_params}",
          nil,
          "Content-Type" => 'application/x-www-form-urlencoded'
        )
        nil
      end

      private

      def merchant_order_id
        CGI.escape payload_hash[:merchantOrderId]
      end

      def payload_hash
        {
          merchantId: CONFIG[:merchantIdentifier]
        }.merge @payload_factory.to_h
      end

      def payload_params
        payload_hash.map{ |k,v| "#{k}=#{CGI.escape(v.to_s)}" }.join '&'
      end

    end
  end
end
