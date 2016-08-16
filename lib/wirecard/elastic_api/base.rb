module Wirecard
  class ElasticApi
    module Base

      # pre-memoization of the response and return self to use entire class afterwards
      def request!
        response
        self
      end

    end
  end
end
