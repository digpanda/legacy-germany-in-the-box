# recover a transaction details from the Wirecard API
module Wirecard
  class ElasticApi
    class Transaction

      include Wirecard::ElasticApi::Base

      VALID_STATUS_LIST = [:success, :failed]

      attr_reader :merchant_id, :transaction_id, :payment_method

      def initialize(merchant_id, transaction_id, payment_method)
        @merchant_id = merchant_id
        @transaction_id = transaction_id
        @payment_method = payment_method
      end

      def response
        @response ||= begin
          response = Utils::Request.new(query, payment_method).response
          if response.nil?
            raise Wirecard::ElasticApi::Error, "The transaction was not found"
          else
            Utils::ResponseFormat.new(self, response)
          end
        end
      end

      # query URI to the API
      def query
        @query ||= "merchants/#{merchant_id}/payments/#{transaction_id}"
      end

      # check the response consistency and raise possible issues
      # if the response got errors, otherwise it continues to process
      # by returning the object itself
      def raise_response_issues
        raise Wirecard::ElasticApi::Error, "The status of the transaction is not correct (#{response.request_status})" unless valid_status?
        raise Wirecard::ElasticApi::Error, "The transaction could not be verified. API access refused." if negative_response?
        self
      end

      private

      def valid_status?
        VALID_STATUS_LIST.include? response.transaction_state
      end

      def negative_response?
        response.transaction_state == :failed && response.request_status == :error
      end

    end
  end
end
