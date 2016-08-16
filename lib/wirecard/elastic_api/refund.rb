module Wirecard
  class ElasticApi
    class Refund

      include Wirecard::ElasticApi::Base

      attr_reader :merchant_id, :parent_transaction_id, :request_id

      def initialize(merchant_id, parent_transaction_id)
        @merchant_id = merchant_id
        @parent_transaction_id = parent_transaction_id
        @request_id = SecureRandom.uuid
      end

      # process the query response
      def response
        @response ||= begin
          response = Utils::Request.new(query, :post, body).response
          # TODO a better response manager with data we need put into a well done class
          if response.nil?
            raise Wirecard::ElasticApi::Error, "The refund was not processed"
          else
            response
          end
        end
      end

      # this will be merged with the engine URL and turned into a query with a body
      def query
        @query ||= "paymentmethods"
      end

      # XML body we will send to the elastic API
      def body
        @body ||= ElasticApi::Utils::XmlBuilder.new(:refund, body_params).to_xml
      end

      private

      # params we will use to fill the XML format request
      def body_params
        {
          :merchant_account_id => merchant_id,
          :request_id => request_id,
          :parent_transaction_id => parent_transaction_id,
          :ip_address => "127.0.0.1"
        }.merge(remote_params)
      end

      # get some body params from the remote elastic API itslef rather than our database (safer)
      def remote_params
        {
          :currency => remote_origin_transaction[:payment][:"requested-amount"][:currency],
          :amount => remote_origin_transaction[:payment][:"requested-amount"][:value],
          :payment_method => remote_origin_transaction[:payment][:"payment-methods"][:"payment-method"].first[:name]
        }
      end

      # original transaction of the refund, requested remotely to elastic API
      def remote_origin_transaction
        @remote_origin_transaction ||= Wirecard::ElasticApi::Transaction.new(merchant_id, parent_transaction_id).response
      end

    end
  end
end
