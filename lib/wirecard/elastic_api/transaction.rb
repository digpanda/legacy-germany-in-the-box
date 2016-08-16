module Wirecard
  class ElasticApi
    class Transaction

      include Wirecard::ElasticApi::Base

      VALID_STATUS_LIST = [:success, :in_progress, :failed, :corrupted]

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
        raise Wirecard::ElasticApi::Error, "The status of the transaction is not correct" unless valid_status?
        symbolize_data(raw_status)
      end

      def type
        symbolize_data(raw_type)
      end

      private

      def symbolize_data(data)
        data.to_s.gsub("-", "_").to_sym
      end

      def valid_status?
        VALID_STATUS_LIST.include? symbolize_data(raw_status)
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
