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

      def status
        symbolize_data(raw_status)
      end

      def type
        symbolize_data(raw_type)
      end

      # check the response consistency and raise possible issues
      # if the response got errors, otherwise it continues to process
      def raise_response_issues
        if valid_status?
          raise Wirecard::ElasticApi::Error, "The status of the transaction is not correct"
        elsif negative_response?
          raise Wirecard::ElasticApi::Error, "The transaction could not be verified"
        end
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
        raw_status == "failed" && response[:payment][:statuses][:status].first[:severity] == "error"
      end

      def raw_type
        response&.[](:payment)&.[](:"transaction-type")
      end

      def raw_status
        response&.[](:payment)&.[](:"transaction-state")
      end

    end
  end
end
