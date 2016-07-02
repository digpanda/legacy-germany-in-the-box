require 'border_guru/error'

module BorderGuru
  module Responses
    class Base

  def devlog
    @@devlog ||= Logger.new(Rails.root.join("log/testing_borderguru.log"))
  end

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
        devlog.info "TESTING BORDERGURU REQUEST : #{@request.response}"
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

