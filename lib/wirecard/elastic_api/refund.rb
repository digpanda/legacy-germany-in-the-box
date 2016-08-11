require 'net/http'

module Wirecard
  class ElasticApi
    class Refund

      attr_reader :merchant_id, :parent_transaction_id, :request_id

      def initialize(merchant_id, parent_transaction_id)
        @merchant_id = merchant_id
        @parent_transaction_id = parent_transaction_id
        @request_id = SecureRandom.uuid
      end

      def response
        @response ||= begin
          response = Request.new(query, :post, body).response
          if response.nil?
            raise Wirecard::ElasticApi::Error, "The refund was not processed"
          else
            response
          end
        end
      end

      def body
        @body ||= ElasticApi::XmlBuilder.new(:refund, body_params).to_xml
      end

      def body_params
        {
          :merchant_account_id => merchant_id,
          :request_id => request_id,
          :parent_transaction_id => parent_transaction_id,
          :ip_address => "127.0.0.1"
        }
      end

      def query
        @query ||= "paymentmethods"
      end

      private

    end
  end
end
