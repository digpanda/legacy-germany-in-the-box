module BorderGuru
  module Requests
    class Base

      class << self
        private
        def read_config
          @config_file ||= ::Rails.application.config.border_guru # IF ANYTHING BREAKS HERE ITS BECAUSE OFT HIS - Laurent on 19/06/2016 (couldn't test if from the hospital)
          #@config_file ||= Psych.load_file(CONFIG_PATH).symbolize_keys 
          #@config_file.fetch(env.to_sym).symbolize_keys
        end
      end

      #CONFIG_PATH = ::Rails.Rails.root + 'config/border_guru.yml' unless const_defined? :CONFIG_PATH

      CONFIG = read_config unless const_defined? :CONFIG

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
        {
          merchantIdentifier: CONFIG[:merchantIdentifier]
        }.merge @payload_factory.to_h
      end

      def quote_params
        CGI.escape(payload_hash.delete_if{ |k, v| v.nil? }.to_json)
      end

    end
  end
end
