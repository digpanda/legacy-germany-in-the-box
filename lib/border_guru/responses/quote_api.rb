require 'border_guru/responses/base'

module BorderGuru
  module Responses
    class QuoteApi < Base

      def line_items
        result['lineItems'].map do |line_item|
          line_item.tap do |h|
            h.keys.each { |k| h[k.underscore] = h.delete(k) }
          end
        end
      end

      def method_missing(method, *args, &block)
        if result.has_key?(camelize(method))
          result[camelize(method)]
        else
          super
        end
      end

      private

      def result
        response_data['result']
      end

      def response_data
        super
      end

    end
  end
end

