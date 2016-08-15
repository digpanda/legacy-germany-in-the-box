#require 'wirecard/base'
#require 'wirecard/api/transaction'

module Wirecard
  class ElasticApi < Base

    class << self

      def transaction(merchant_id, transaction_id)
        ElasticApi::Transaction.new(merchant_id, transaction_id)
      end

      def refund(merchant_id, parent_transaction_id)
        ElasticApi::Transaction.new(merchant_id, parent_transaction_id)
      end
      
    end

  end
end
