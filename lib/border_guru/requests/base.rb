module BorderGuru
  module Requests
    class Base

      include ErrorsHelper

      CONFIG = Rails.application.config.border_guru unless const_defined? :CONFIG

      @@access_token =
        OAuth::AccessToken.new(OAuth::Consumer.new(
          CONFIG[:key],
          CONFIG[:secret],
          site: CONFIG[:host].chomp('/'),
          scheme: 'query_string')
        )

      def initialize(payload_factory)
        @payload_factory = payload_factory
      end

      def response
        @raw_response
      end

      private

      def payload_hash
        merchant_identifier_hash.merge @payload_factory.to_h
      end

      def merchant_identifier_hash
        {merchantIdentifier: CONFIG[:merchantIdentifier]}
      end

      def quote_params
        # temporary check of all transactions given to BorderGuru
        warn_developers(StandardError.new, "#{quote_params}")
        CGI.escape(payload_hash.to_json)
      end

    end
  end
end
