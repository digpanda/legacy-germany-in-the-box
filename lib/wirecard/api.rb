require 'net/http'

# this library is currently not tested
# be careful
module Wirecard
  class Api < Base

    class << self
      
      def transaction(merchant_id, transaction_id)
        Transaction.new(merchant_id, transaction_id)
      end

    end

  end
end
