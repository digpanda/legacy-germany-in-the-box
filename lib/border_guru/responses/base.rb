module BorderGuru
  module Responses
    class Base

      def initialize(finished_request)
        @request = finished_request
      end

      def success?
        !!response_data['success']
      end

      private

      def camelize(str)
        str.to_s.camelize.sub(/^(.)/){|s| s.downcase}
      end

      def response_data
        JSON.parse(@request.response.body)
      rescue JSON::ParserError => e
        Rails.logger.error("JSON-parsing of #{@request.response.body} raised an error:")
        raise e
      end


    end
  end
end

