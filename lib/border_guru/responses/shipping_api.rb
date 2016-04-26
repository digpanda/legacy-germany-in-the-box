require 'border_guru/responses/base'

module BorderGuru
  module Responses
    class ShippingApi < Base

      def shipment_identifier
        response_data['result']
      end

      def link_payment
        response_data['linkPayment']
      end

      def method_missing(method, *args, &block)
        if response_data.has_key?(camelize(method))
          response_data[camelize(method)]
        else
          super
        end
      end

      def response_data
        super['response']
      end

    end
  end
end

