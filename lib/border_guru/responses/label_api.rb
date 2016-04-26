require 'border_guru/responses/base'

module BorderGuru
  module Responses
    class LabelApi < Base

      def bindata
        @request.response.body
      end

      def success?
        !!bindata && Net::HTTPSuccess === @request.response
      end

    end
  end
end


