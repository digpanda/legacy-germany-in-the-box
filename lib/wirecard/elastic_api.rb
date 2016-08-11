#require 'wirecard/base'
#require 'wirecard/api/transaction'

module Wirecard
  class ElasticApi < Base

    class << self

      def transaction(merchant_id, transaction_id)
        ElasticApi::Transaction.new(merchant_id, transaction_id)
      end

    end

  end
end
