require 'border_guru/error'

module BorderGuru
  module Responses
    class Base

      def devlog
        @@devlog ||= Logger.new(Rails.root.join("log/testing_borderguru.log"))
      end

      HTTP_ERRORS = [
        Net::HTTPBadRequest,
        Net::HTTPBadResponse,
        Net::HTTPHeaderSyntaxError,
        Net::ProtocolError,
        Net::ReadTimeout
      ]

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
        devlog.info "TESTING BORDERGURU REQUEST AGAIN : #{@request}"
        devlog.info "TESTING BORDERGURU REQUEST RESPONSE : #{@request.response}"
        response_body = JSON.parse(@request.response.body)
        raise BorderGuru::Error.new response_body["error"]["message"] if response_body["error"]
        response_body["response"]
      rescue Exception => e
        devlog.info "TESTING BORDERGURU ERROR CATCHED (GLOBAL) : #{e}"
        logger.fatal "Failed to connect to Borderguru: #{e}"
        flash[:error] = "We are having trouble communicating with our shipping partner. #{e.message}. Please try again in a few minutes." # I18n.t(:borderguru_unreachable_at_quoting, scope: :checkout)
        redirect_to root_path and return
      rescue *HTTP_ERRORS => e
        devlog.info "TESTING BORDERGURU ERROR CATCHED : #{e}"
        logger.fatal "Failed to connect to Borderguru: #{e}"
        flash[:error] = "We are having trouble communicating with our shipping partner. #{e.message}. Please try again in a few minutes." # I18n.t(:borderguru_unreachable_at_quoting, scope: :checkout)
        redirect_to root_path and return
      rescue JSON::ParserError => e
        Rails.logger.error("JSON-parsing of #{@request.response.body} raised an error:")
        raise e
      end
    end
  end
end

