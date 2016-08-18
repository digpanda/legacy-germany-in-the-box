require 'rexml/text'

module Wirecard
  class ElasticApi
    module Utils
      class ResponseFormat

        RESPOND_WITH_SYMBOL = [:request_status, :status, :type, :payment_method]

        attr_reader :origin, :raw

        class << self
          def to_call(method_name)
            "raw_#{method_name}".to_sym
          end
        end

        def initialize(origin, raw)
          @origin = origin
          @raw = raw
        end

        def method_missing(method_symbol, *arguments, &block)
          to_call = ResponseFormat.to_call(method_symbol)
          if self.respond_to?(to_call)
            response = self.send(to_call)
            symbolize_data(response) if RESPOND_WITH_SYMBOL.include?(method_symbol)
          end
        end

        def raw_request_status; cycle(:payment, :statuses, :status, 0, :severity); end
        def raw_currency; cycle(:payment, :"requested-amount", :currency); end
        def raw_amount; cycle(:payment, :"requested-amount", :value); end
        def raw_type; cycle(:payment, :"transaction-type"); end
        def raw_status; cycle(:payment, :"transaction-state"); end
        def raw_payment_method; cycle(:payment, :"payment-methods", :"payment-method", 0, :name); end

        private

        # cool method to try to go through a hash, could be WAY improved
        # but who got time for that ?
        def cycle(*elements)
          position = raw
          elements.each do |element|
            position = position&.[](element)
            return position if position.nil?
          end
          position
        end

        def symbolize_data(data)
          data.to_s.gsub("-", "_").to_sym
        end

      end
    end
  end
end
