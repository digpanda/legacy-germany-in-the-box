require 'border_guru/responses/base'

module BorderGuru
  module Responses
    class QuoteApi < Base

      def line_items
        result[:lineItems].map do |line_item|
          line_item.tap do |h|
            h.keys.each { |k| h[k.to_s.underscore.to_sym] = h.delete(k) }
          end
        end
      end

      def method_missing(method, *args, &block)
        if result.has_key?(camelize(method).to_sym)
          result[camelize(method).to_sym]
        else
          super
        end
      end

      private

      def result
        if response_data.nil?
          raise BorderGuru::Error, "Logistic partner busy. Please try again in a few minutes."
        end
        response_data[:result]
      end

      def response_data
        super[:response]
      end

    end
  end
end
