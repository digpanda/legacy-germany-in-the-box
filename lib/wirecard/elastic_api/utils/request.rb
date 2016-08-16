require 'net/http'

module Wirecard
  class ElasticApi
    module Utils
      class Request

        CONFIG = Wirecard::ElasticApi::BASE_CONFIG[:elastic_api]
        CONTENT_TYPE = 'text/xml'

        attr_reader :engine_url, :username, :password, :query, :method, :body

        def initialize(uri_query, method=:get, body='')
          @engine_url = CONFIG[:engine_url]
          @username = CONFIG[:username]
          @password = CONFIG[:password]
          @query = "#{engine_url}#{uri_query}.json"
          @method = method
          @body = body
        end

        def raw_response
          @raw_response ||= Net::HTTP.start(request_uri.host, request_uri.port,
                                :use_ssl     => https_request?,
                                :verify_mode => OpenSSL::SSL::VERIFY_NONE) { |connection| dispatch!(connection) }
        end

        def response
          @response ||= JSON.parse(raw_response.body).deep_symbolize_keys unless raw_response.body.nil?
        end

        private

        def dispatch!(connection)
          request.basic_auth username, password # authentification here
          request.body = body # body (XML for instance)
          request.content_type = CONTENT_TYPE # XML
          connection.request request # give a response
        end

        def request
          @request ||= begin
            if method == :get
              Net::HTTP::Get.new(request_uri.request_uri)
            elsif method == :post
              Net::HTTP::Post.new(request_uri.request_uri)
            else
              raise Wirecard::ElasticApi::Error, "Request method not recognized"
            end
          end
        end

        def request_uri
          @request_uri ||= URI(query)
        end

        def https_request?
          request_uri.scheme == 'https'
        end

      end
    end
  end
end
