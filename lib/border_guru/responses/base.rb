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
        if response_body.dig("response", "error")
          response_body["response"]["error"]["description"]
        end
      end

      def reason_error
        if response_body.dig("reason", "msg")
          response_body["reason"]["msg"]
        end
      end

      def camelize(str)
        str.to_s.camelize.sub(/^(.)/){|s| s.downcase}
      end

      def response_body
        @response_body ||= JSON.parse(@request.response.body)
      rescue JSON::ParserError => e
        Rails.logger.error("Tried to JSON.parse an incompatible body #{e}")
        @response_body = {} # never fails
      end

    end
  end
end

