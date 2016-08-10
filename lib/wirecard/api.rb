#require 'wirecard/base'
#require 'wirecard/api/transaction'

module Wirecard
  class Api < Base

    class << self

      def transaction(merchant_id, transaction_id)
        Transaction.new(merchant_id, transaction_id)
      end

    end

  end
end
