require 'border_guru/error'

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

      def response_data
        raise BorderGuru::Error.new error unless error.nil?
        response_body
      end

      # had a big struggle to differentiate the different errors type depending on the request
      # it seems borderguru don't always answer the same way to errors
      # rather than handling it for each request we will try each successively and hopefully return a nil
      def error
        global_error || response_error || reason_error
      end

      def global_error
        response_body["error"]["description"] if response_body["error"]
      end

      def response_error
        if response_body["response"] && response_body["response"]["error"]
          response_body["response"]["error"]["description"]
        end
      end

      def reason_error
        response_body["reason"]["msg"] if response_body["reason"]
      end

      def camelize(str)
        str.to_s.camelize.sub(/^(.)/){|s| s.downcase}
      end

      def response_body
        @response_body ||= JSON.parse(@request.response.body)
      rescue JSON::ParserError => e
        Rails.logger.error("JSON-parsing of #{@request.response.body} raised an error:")
        raise e
      end

    end
  end
end

