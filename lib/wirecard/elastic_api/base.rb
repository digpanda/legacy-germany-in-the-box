module Wirecard
  class ElasticApi
    module Base

      # pre-memoization of the response to use multiple methods afterwards
      def request!
        response
        self
      end

    end
  end
end
