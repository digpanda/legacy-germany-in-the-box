module Wirecard
  class Customer

    include Rails.application.routes.url_helpers # manipulate paths

    require 'net/http'
    require 'digest'

    attr_reader :user,
                :merchant_id, 
                :secret_key,  
                :hosted_payment_url, 
                :amount, 
                :currency, 
                :order_number,
                :request_id, 
                :order_detail, 
                :request_time_stamp,  
                :request_id, 
                :default_redirect_url,
                :success_redirect_url,
                :fail_redirect_url

    def initialize(user, args={})

      @user                = user
      @merchant_id         = args[:merchant_id]
      @secret_key          = args[:secret_key]
      @amount              = args[:amount].to_s
      @currency            = args[:currency]
      @order_number        = args[:order_number]
      @order_detail        = args[:order_detail]
      @request_time_stamp  = timestamp
      @request_id          = [timestamp, user.id, order_number].join('-')
      @hosted_payment_url  = ::Rails.application.config.wirecard[:customers][:hosted_payment_url]
      @default_redirect_url= ::Rails.application.config.wirecard[:customers][:default_redirect_url]
      @success_redirect_url= ::Rails.application.config.wirecard[:customers][:success_redirect_url] || "#{default_redirect_url}?state=success&"
      @fail_redirect_url   = ::Rails.application.config.wirecard[:customers][:fail_redirect_url] || "#{default_redirect_url}?state=failed&"

    end

    def hosted_payment_datas

      {
        :requested_amount          => amount,
        :requested_amount_currency => currency,
        :locale                    => 'en', # TODO : SHOULD BE SOMETHING ELSE ?
        :order_number              => order_number,
        :order_detail              => order_detail,
        :form_url                  => hosted_payment_url,
        :request_id                => request_id,
        :request_time_stamp        => request_time_stamp,
        :merchant_account_id       => merchant_id,
        :payment_method            => ::Rails.application.config.wirecard[:customers][:payment_method],
        :transaction_type          => ::Rails.application.config.wirecard[:customers][:transaction_type],
        :redirect_url              => success_redirect_url.html_safe,
        :request_signature         => digital_signature,
        :psp_name                  => ::Rails.application.config.wirecard[:customers][:psp_name],
        :success_redirect_url      => success_redirect_url.html_safe,
        :fail_redirect_url         => fail_redirect_url.html_safe,
        :cancel_redirect_url       => "#{default_redirect_url}?state=cancel&".html_safe,
        :processing_redirect_url   => "#{default_redirect_url}?state=processing&".html_safe,
        
        #:first_name                => user.fname,
        #:last_name                 => user.lname,

        :email                     => user.email,
        :phone                     => user.tel,
        :street1                   => user.addresses.first.decorate.street_and_number,
        :street2                   => "",
        :city                      => user.addresses.first.city,
        :state                     => user.addresses.first.province,
        :postal_code               => user.addresses.first.zip,
        :country                   => user.addresses.first.country.alpha2,
        :ip_address                => "127.0.0.1"
      }

    end

    def digital_signature

      # WARNING : the order of the hash matters
      signature = {

        :request_time_stamp      => request_time_stamp,
        :request_id              => request_id,
        :merchant_account_id     => merchant_id,
        :transaction_type        => ::Rails.application.config.wirecard[:customers][:transaction_type],
        :requested_amount        => amount,
        :request_amount_currency => currency,
        :redirect_url            => success_redirect_url.html_safe,
        :ip_address              => "127.0.0.1",
        :secret_key              => secret_key
      
      }

      Digest::SHA256.hexdigest(signature.values.join.squish)

    end

    def timestamp
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end



  end
end