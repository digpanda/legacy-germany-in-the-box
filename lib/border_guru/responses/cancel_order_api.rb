require 'border_guru/responses/base'

module BorderGuru
  module Responses
    class CancelOrderApi < Base

      def reason
        response_data['reason']
      end
      
    end
  end
end


