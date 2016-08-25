require 'border_guru/responses/base'

module BorderGuru
  module Responses
    class LabelApi < Base

      DEFAULT_ERROR_RESPONSE = "Impossible to get the label."

      def bindata
        raise BorderGuru::Error.new error_message unless pdf?
        @request.response.body
      end

      # added to seet the error more clearly
      def raw_body
        @request.response.body
      end

      def success?
        !!bindata && Net::HTTPSuccess === @request.response
      end

      private

      def error_message
        error || DEFAULT_ERROR_RESPONSE
      end

      def pdf? # if it's not a pdf, it's a json (let's hope.)
        @request.response.content_type == "application/pdf"
      end

    end
  end
end
