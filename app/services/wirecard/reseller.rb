module Wirecard
  class Reseller

    require 'net/http'

    attr_reader :username, 
                :password, 
                :engine_url,
                :merchant_id,
                :transaction_id

    def initialize(args={})

      @username ||= ::Rails.application.config.wirecard["reseller"]["username"]
      @password ||= ::Rails.application.config.wirecard["reseller"]["password"]
      @engine_url ||= ::Rails.application.config.wirecard["reseller"]["engine_url"]

      @merchant_id = args[:merchant_id]

      basic_authentication # authentification to the engine

    end

    def transaction(transaction_id)

      transaction_query_url(transaction_id)

    end

    def basic_authentication
      uri = URI(engine_url) # auth page could be improved to avoid 404
      Net::HTTP.start(uri.host, uri.port,
        :use_ssl => uri.scheme == 'https', 
        :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

        request = Net::HTTP::Get.new uri.request_uri
        request.basic_auth username, password

        response = http.request request
        response.body
      end
    end

    def transaction_query_url(transaction_id)
      "#{engine_url}merchants/#{merchant_id}/payments/#{transaction_id}.json"
    end

  end
end