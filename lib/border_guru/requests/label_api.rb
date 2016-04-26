require_relative 'base'

module BorderGuru
  module Requests
    class LabelApi < Base

      def dispatch!
        @raw_response = @@access_token.get(
          # "/api/orders/label/#{border_guru_shipment_id}?quoteParams=#{quote_params}",
          # without quote_params it still works:
          "/api/orders/label/#{border_guru_shipment_id}",
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
