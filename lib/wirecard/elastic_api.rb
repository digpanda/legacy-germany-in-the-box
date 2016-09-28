#require 'wirecard/base'
#require 'wirecard/api/transaction'

module Wirecard
  class ElasticApi < Base

    class << self

      def transaction(merchant_id, transaction_id, payment_method)
        ElasticApi::Transaction.new(merchant_id, transaction_id, payment_method)
      end

      def refund(merchant_id, parent_transaction_id, payment_method)
        ElasticApi::Refund.new(merchant_id, parent_transaction_id, payment_method)
      end

    end

  end
end
