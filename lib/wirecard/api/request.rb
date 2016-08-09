require 'net/http'

module Wirecard
  class Api
    class Request

      CONFIG = Wirecard::Reseller::BASE_CONFIG[:reseller]
      attr_reader :engine_url, :username, :password, :query

      def initialize(uri_query)
        @engine_url = CONFIG[:engine_url]
        @username = CONFIG[:username]
        @password = CONFIG[:password]
        @query = "#{engine_url}#{uri_query}.json"
      end

      def request!
        Net::HTTP.start(request_uri.host, request_uri.port,
        :use_ssl     => https_request?,
        :verify_mode => OpenSSL::SSL::VERIFY_NONE) { |connection| dispatch!(connection).body }
      end

      def https_request?
        request_uri.scheme == 'https'
      end

      def dispatch!(connection)
        request = Net::HTTP::Get.new request_uri.request_uri # prepare the request
        request.basic_auth username, password # authentification here
        connection.request request # give a response
      end

      def request_uri
        @request_uri ||= URI(query)
      end

      def response
        @response ||= JSON.parse(request!).deep_symbolize_keys
      end

    end
  end
end
