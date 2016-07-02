require 'border_guru/error'

module BorderGuru
  module Responses
    class Base

      def initialize(finished_request)
        @request = finished_request
        Rails.logger.error("TESTING BORDERGURU REQUEST : #{@request}")
      end

      def success?
        !!response_data['success']
      end

      private

      def camelize(str)
        str.to_s.camelize.sub(/^(.)/){|s| s.downcase}
      end

      def response_data
        response_body = JSON.parse(@request.response.body)
        raise BorderGuru::Error.new response_body["error"]["message"] if response_body["error"]
        response_body["response"]
      rescue JSON::ParserError => e
        Rails.logger.error("JSON-parsing of #{@request.response.body} raised an error:")
        raise e
      end
    end
  end
end

