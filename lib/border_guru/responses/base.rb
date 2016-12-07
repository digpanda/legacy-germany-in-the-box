require 'border_guru/error'

module BorderGuru
  module Responses
    class Base

      def initialize(finished_request)
        @request = finished_request
      end

      def success?
        !!response_data[:success]
      end

      def slack_feedback
        SlackDispatcher.new.message("#{@request.response.body}")
      end
      
      private

      # it's the same variable as response_body, maybe we should change this duplicate and also symbolize everything
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
        response_body[:error][:description] if response_body[:error]
      end

      def response_error
        if response_body.dig(:response, :error)
          response_body[:response][:error][:description]
        end
      end

      def error_message
        if response_body.dig(:error)
          response_body[:error][:message]
        end
      end

      def reason_error
        if response_body.dig(:success) && response_body[:success] == false
          response_body[:reason][:message]
        end
      end

      def camelize(str)
        str.to_s.camelize.sub(/^(.)/){|s| s.downcase}
      end

      # after examination the response_body is transmitted to response_data and we should manage
      # the errors better by analysing what it does in the system
      # sometimes it's not JSON, there's a very bad error handling system behind all that
      def response_body
        @response_body ||= JSON.parse(@request.response.body).deep_symbolize_keys
      rescue JSON::ParserError => e
        Rails.logger.error("Tried to JSON.parse an incompatible body : #{e}")
        raise BorderGuru::Error.new e
      ensure
        @response_body
      end

    end
  end
end
