require_relative 'base'

module BorderGuru
  module Requests
    class CancelOrderApi < Base

      def dispatch!
        @raw_response = @@access_token.post(
          "/api/orders/cancelOrder/#{CONFIG[:merchantIdentifier]}/#{border_guru_shipment_id}",
          nil,
          "Content-Type" => 'application/x-www-form-urlencoded'
        )
        nil
      end

      private

      def border_guru_shipment_id
        payload_hash[:shipmentIdentifier]
      end

    end
  end
end
