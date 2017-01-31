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

      def result
        if response_data.nil?
          slack_feedback
          if error_message
            raise BorderGuru::Error, error_message
          else
            raise BorderGuru::Error, I18n.t(:borderguru_unreachable_at_quoting, scope: :checkout)
          end
        end
        response_data[:result]
      end

      private

      def response_data
        super[:response]
      end

    end
  end
end
