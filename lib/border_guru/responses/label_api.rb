require 'border_guru/responses/base'

module BorderGuru
  module Responses
    class LabelApi < Base

      DEFAULT_ERROR_RESPONSE = "Impossible to get the label."

      def bindata
        raise BorderGuru::Error.new error_message unless pdf?
        @request.response.body
      end

      private

      def error_message
        error || DEFAULT_ERROR_RESPONSE
      end

      def pdf? # if it's not a pdf, it's a json (let's hope.)
        @request.response.content_type == "application/pdf"
      end

      # it doesn't seem it's currently in use
      def success?
        !!bindata && Net::HTTPSuccess === @request.response
      end

    end
  end
end


