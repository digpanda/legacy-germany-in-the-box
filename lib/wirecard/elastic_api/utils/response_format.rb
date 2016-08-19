require 'rexml/text'

module Wirecard
  class ElasticApi
    module Utils
      class ResponseFormat

        SYMBOLS_MAP = [:request_status, :status, :transaction_type, :payment_method]

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
            if SYMBOLS_MAP.include?(method_symbol)
              symbolize_data(response)
            else
              response
            end
          end
        end

        # TODO : improve this to be normed to the API names
        def raw_request_status; cycle(:statuses, :status, 0, :severity); end
        def raw_currency; cycle(:"requested-amount", :currency); end
        def raw_requested_amount; cycle(:"requested-amount", :value); end
        def raw_transaction_type; cycle(:"transaction-type"); end
        def raw_status; cycle(:"transaction-state"); end
        def raw_payment_method; cycle(:"payment-methods", :"payment-method", 0, :name); end

        private

        # cool method to try to go through a hash, could be WAY improved
        # but who got time for that ?
        def cycle(*elements)
          position = raw[:payment] || raw[:payment]&.[](:"merchant-account-id")
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
