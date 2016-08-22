module Wirecard
  class ElasticApi
    class Refund

      REQUEST_IP_ADDRESS = "127.0.0.1"
      REFUND_MAP = {:purchase => :'refund-purchase', :debit => :'refund-debit'}

      include Wirecard::ElasticApi::Base

      attr_reader :merchant_id, :parent_transaction_id, :request_id

      def initialize(merchant_id, parent_transaction_id)
        @merchant_id = merchant_id
        @parent_transaction_id = parent_transaction_id
        @request_id = SecureRandom.uuid
      end

      # process the query response
      # return the response format
      def response
        @response ||= begin
          response = Utils::Request.new(query, :post, body).response
          if response.nil?
            raise Wirecard::ElasticApi::Error, "The refund was not processed"
          else
            Utils::ResponseFormat.new(self, response)
          end
        end
      end

      # query URI to the API
      def query
        if parent_transaction.response.transaction_type == :purchase
          @query ||= "payments"
        elsif parent_transaction.response.transaction_type == :debit
          @query ||= "paymentmethods"
        end
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
          :ip_address => REQUEST_IP_ADDRESS
        }.merge(remote_params)
      end

      # get some body params from the remote elastic API itslef rather than our database (safer)
      def remote_params
        {
          :currency => parent_transaction.response.currency,
          :amount => parent_transaction.response.requested_amount,
          :payment_method => parent_transaction.response.payment_method, # potential bug because it's a symbol ?
          :transaction_type => refund_transaction_type
        }
      end

      def refund_transaction_type
        REFUND_MAP[parent_transaction.response.transaction_type]
      end

      # original transaction of the refund, requested remotely to elastic API
      def parent_transaction
        @parent_transaction ||= Wirecard::ElasticApi::Transaction.new(merchant_id, parent_transaction_id)
      end

    end
  end
end
