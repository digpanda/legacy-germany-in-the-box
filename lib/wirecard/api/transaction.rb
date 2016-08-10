require 'net/http'

module Wirecard
  class Api
    class Transaction

      VALID_STATUS_LIST = [:success, :in_progress, :failed, :corrupted]

      attr_reader :merchant_id, :transaction_id

      def initialize(merchant_id, transaction_id)
        @merchant_id = merchant_id
        @transaction_id = transaction_id
      end

      def response
        @response ||= begin
          response = Request.new(query).response
          if response.nil?
            raise Wirecard::Api::Error, "The transaction was not found"
          else
            response
          end
        end
      end

      def query
        @query ||= "merchants/#{merchant_id}/payments/#{transaction_id}"
      end

      def status
        raise Wirecard::Api::Error, "The status of the transaction was not found" unless valid_status?
        clean_status
      end

      private

      def symbolize_status(status)
        status.to_s.gsub("-", "_").to_sym
      end

      def valid_status?
        VALID_STATUS_LIST.include? clean_status
      end

      def clean_status
        symbolize_status(raw_status)
      end

      def raw_status
        response&.[](:payment)&.[](:"transaction-state")
      end

    end
  end
end
