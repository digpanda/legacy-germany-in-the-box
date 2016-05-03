module Wirecard
  class Reseller

    require 'net/http'

    attr_reader :username, 
                :password, 
                :engine_url,
                :merchant_id,
                :transaction_id,

    def initialize(args={})

      @username ||= ::Rails.application.config.wirecard["reseller"]["username"]
      @password ||= ::Rails.application.config.wirecard["reseller"]["password"]
      @engine_url ||= ::Rails.application.config.wirecard["reseller"]["engine_url"]

      @merchant_id = args[:merchant_id]

    end

    def transaction(transaction_id)

      # TESTING VARIABLE
      transaction_id = "af3864e1-0b2b-11e6-9e82-00163e64ea9f"
      JSON.parse(get_with_authentification(transaction_query_url(transaction_id)))

    end

    def get_with_authentification(raw_url)
      uri = URI(raw_url)
      Net::HTTP.start(uri.host, uri.port,
        :use_ssl     => uri.scheme == 'https', 
        :verify_mode => OpenSSL::SSL::VERIFY_NONE) { |http| make_http_request(http, uri).body }
    end

    def make_http_request(http, uri)
      request = Net::HTTP::Get.new uri.request_uri # prepare the request
      request.basic_auth username, password # authentification here
      http.request request # give a response
    end

    def transaction_query_url(transaction_id)
      "#{engine_url}merchants/#{merchant_id}/payments/#{transaction_id}.json"
    end

  end
end