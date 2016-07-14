require 'net/http'
require 'digest'

module Wirecard
  class Customer

    include Rails.application.routes.url_helpers # manipulate paths

    CONFIG = ::Rails.application.config.wirecard[:customers]
    DEFAULT_PAYMENT_LANGUAGE = 'en'
    DEFAULT_PAYMENT_CURRENCY = 'CNY'

    Error = Class.new(StandardError)

    attr_reader :user,
                :merchant_id, 
                :secret_key,  
                :hosted_payment_url, 
                :amount, 
                :currency, 
                :request_id, 
                :order_number,
                :request_time_stamp,  
                :request_id, 
                :default_redirect_url,
                :order


    def initialize(user, args={})

      raise Error, "Wrong arguments given" unless valid_args?(args)

      @user                = user
      @order               = args[:order]
      @merchant_id         = args[:merchant_id]
      @secret_key          = args[:secret_key]

      @currency            = DEFAULT_PAYMENT_CURRENCY
      @order_number        = "#{order.id}"
      @amount              = order.total_price_in_yuan.to_f

      @request_time_stamp  = time_stamp
      @request_id          = [request_time_stamp, user.id, order_number].join('-')
      @hosted_payment_url  = CONFIG[:hosted_payment_url]
      @default_redirect_url= CONFIG[:default_redirect_url]

    end

    def hosted_payment_datas

      {
        :requested_amount          => amount,
        :requested_amount_currency => DEFAULT_PAYMENT_CURRENCY,
        :locale                    => DEFAULT_PAYMENT_LANGUAGE,
        :order_number              => order_number,
        :order_detail              => order.desc,
        :form_url                  => hosted_payment_url,
        :request_id                => request_id,
        :request_time_stamp        => request_time_stamp,
        :merchant_account_id       => merchant_id,
        :payment_method            => CONFIG[:payment_method],
        :transaction_type          => CONFIG[:transaction_type],
        :redirect_url              => success_redirect_url.html_safe,
        :request_signature         => digital_signature,
        :psp_name                  => CONFIG[:psp_name],
        :success_redirect_url      => success_redirect_url.html_safe,
        :fail_redirect_url         => fail_redirect_url.html_safe,
        :cancel_redirect_url       => cancel_redirect_url.html_safe,
        :processing_redirect_url   => processing_redirect_url.html_safe,
        
        #:first_name                => user.fname,
        #:last_name                 => user.lname,

        :email                     => user.email,
        :phone                     => user.tel,
        :street1                   => order.billing_address.decorate.street_and_number,
        :street2                   => "",
        :city                      => order.billing_address.city,
        :state                     => order.billing_address.province,
        :postal_code               => order.billing_address.zip,
        :country                   => order.billing_address.country.alpha2,
        :ip_address                => "127.0.0.1"
      }

    end

    private

    def cancel_redirect_url
      "#{default_redirect_url}?state=cancel&"
    end

    def processing_redirect_url
      "#{default_redirect_url}?state=processing&"
    end

    def success_redirect_url
      CONFIG[:success_redirect_url] || "#{default_redirect_url}?state=success&"
    end

    def fail_redirect_url
      CONFIG[:fail_redirect_url] || "#{default_redirect_url}?state=failed&"
    end

    def digital_signature
      Digest::SHA256.hexdigest(signature_hash.values.join.squish)
    end

    def signature_hash

      # WARNING : the order of the hash matters
      {

        :request_time_stamp      => request_time_stamp,
        :request_id              => request_id,
        :merchant_account_id     => merchant_id,
        :transaction_type        => CONFIG[:transaction_type],
        :requested_amount        => amount,
        :request_amount_currency => currency,
        :redirect_url            => success_redirect_url.html_safe,
        :ip_address              => "127.0.0.1",
        :secret_key              => secret_key
      
      }

    end

    def time_stamp
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def valid_args?(args)
      args[:order] && args[:merchant_id] && args[:secret_key]
    end

  end
end