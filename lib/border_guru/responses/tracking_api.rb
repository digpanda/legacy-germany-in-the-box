require 'border_guru/responses/base'

module BorderGuru
  module Responses
    class TrackingApi < Base

      def success?
        Net::HTTPSuccess === @request.response
      end

    end
  end
end


