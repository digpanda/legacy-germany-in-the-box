module Wirecard
  class ElasticApi
    class Transaction

      include Wirecard::ElasticApi::Base

      VALID_STATUS_LIST = [:success, :failed]

      attr_reader :merchant_id, :transaction_id

      def initialize(merchant_id, transaction_id)
        @merchant_id = merchant_id
        @transaction_id = transaction_id
      end

      def response
        @response ||= begin
          response = Utils::Request.new(query).response
          if response.nil?
            raise Wirecard::ElasticApi::Error, "The transaction was not found"
          else
            response
          end
        end
      end

      def query
        @query ||= "merchants/#{merchant_id}/payments/#{transaction_id}"
      end

      # we should put it into another class showing the formatted response
      def status
        symbolize_data(raw_status)
      end

      def type
        symbolize_data(raw_type)
      end

      def method
        symbolize_data(raw_method)
      end

      def amount
        raw_amount
      end

      # check the response consistency and raise possible issues
      # if the response got errors, otherwise it continues to process
      # by returning the object itself
      def raise_response_issues
        raise Wirecard::ElasticApi::Error, "The status of the transaction is not correct" unless valid_status?
        raise Wirecard::ElasticApi::Error, "The transaction could not be verified. API access refused." if negative_response?
        self
      end

      private

      def symbolize_data(data)
        data.to_s.gsub("-", "_").to_sym
      end

      def valid_status?
        VALID_STATUS_LIST.include? symbolize_data(raw_status)
      end

      def negative_response?
        raw_status == "failed" && raw_request_status == "error"
      end

      # TODO : we should put it into another class showing the formatted response
      # could be recursive and nice via metaprogramming
      def raw_request_status
        try_fetch(response, :payment, :statuses, :status, 0, :severity)
      end

      def raw_currency
        try_fetch(response, :payment, :"requested-amount", :currency)
      end

      def raw_amount
        try_fetch(response, :payment, :"requested-amount", :value)
      end

      def raw_type
        try_fetch(response, :payment, :"transaction-type")
      end

      def raw_status
        try_fetch(response, :payment, :"transaction-state")
      end

      def raw_method
        try_fetch(response, :payment, :"payment-methods", :"payment-method", 0, :name)
      end

      # cool method to try to go through a hash, could be improved.
      def try_fetch(source, *elements)
        position = source
        elements.each do |element|
          position = position&.[](element)
          return position if position.nil?
        end
        position
      end

    end
  end
end
