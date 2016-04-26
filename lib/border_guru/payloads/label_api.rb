module BorderGuru
  module Payloads
    class LabelApi

      def initialize(border_guru_shipment_id:)
        @border_guru_shipment_id = border_guru_shipment_id
      end

      def to_h
        {
          shipmentIdentifier: @border_guru_shipment_id
        }
      end

    end
  end
end
