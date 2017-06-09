require 'net/http'
require 'digest'

module Wirecard
  class Hpp < Base

    CONFIG = BASE_CONFIG[:hpp]
    DEFAULT_PAYMENT_LANGUAGE = 'zh_CN'
    DEFAULT_PAYMENT_CURRENCY = 'CNY'
    ACCEPTED_PAYMENT_METHODS = [nil, :upop, :creditcard]

    attr_reader :base_url,
                :user,
                :order,
                :credentials,
                :merchant_id,
                :secret_key,
                :payment_method,
                :request_id,
                :currency,
                :hosted_payment_url,
                :default_redirect_url


    def initialize(base_url, user, order, credentials={})

      @base_url             = base_url
      @user                 = user
      @order                = order
      @credentials          = credentials

      raise Error, "Wrong arguments given" unless valid_credentials?(credentials)
      raise Error, "Payment method not authorized" unless ACCEPTED_PAYMENT_METHODS.include?(payment_method)

      @merchant_id          = credentials[:merchant_id]
      @secret_key           = credentials[:secret_key]
      @payment_method       = credentials[:payment_method]

      @request_id           = SecureRandom.uuid
      @currency             = DEFAULT_PAYMENT_CURRENCY

      @hosted_payment_url   = CONFIG[payment_method][:hosted_payment_url]
    end

    def amount
      @amount ||= order.end_price.in_euro.to_yuan.amount.round(2)
    end

    def transaction_type
      CONFIG[:transaction_types][payment_method] || CONFIG[:transaction_types][:default]
    end

    def hosted_payment_datas
      mandatory_datas.merge(optional_datas)
    end

    private

    def mandatory_datas
      transaction_datas.merge(redirection_datas)
    end

    def optional_datas
      transaction_details_datas.merge(customer_datas)
    end

    def transaction_datas
      {
        :form_url                  => hosted_payment_url,
        :request_id                => request_id,
        :request_time_stamp        => request_time_stamp,
        :merchant_account_id       => merchant_id,
        :transaction_type          => transaction_type,
        :requested_amount          => amount,
        :requested_amount_currency => DEFAULT_PAYMENT_CURRENCY,
        :attempt_three_d           => false,
        :ip_address                => customer_ip_address,
        :request_signature         => digital_signature,
      }
    end

    def transaction_details_datas
      {
        :psp_name                  => CONFIG[payment_method][:psp_name],
        :notification_url        => CONFIG[payment_method][:notification_url],
        :notification_transaction_state => 'success',
        :locale                    => DEFAULT_PAYMENT_LANGUAGE,
        :order_number              => "#{order.id}",
        :order_detail              => order.desc,
        :payment_method            => payment_method,
      }
    end

    def redirection_datas
      {
        :redirect_url              => success_redirect_url.html_safe,
        :success_redirect_url      => success_redirect_url.html_safe,
        :fail_redirect_url         => fail_redirect_url.html_safe,
        :cancel_redirect_url       => cancel_redirect_url.html_safe,
        :processing_redirect_url   => processing_redirect_url.html_safe,
      }
    end

    def customer_datas
      {
        #:first_name                => user.fname,
        #:last_name                 => user.lname,
        :email                     => user.email,
        :tel                     => user.mobile,
        :street1                   => order.billing_address.decorate.street_and_number,
        :street2                   => "",
        :city                      => order.billing_address.city,
        :state                     => order.billing_address.province,
        :postal_code               => order.billing_address.zip,
        :country                   => order.billing_address.country.alpha2,
      }
    end

    # /!\ WARNING
    # the order of the hash matters
    def signature_hash
      {
        :request_time_stamp      => request_time_stamp,
        :request_id              => request_id,
        :merchant_account_id     => merchant_id,
        :transaction_type        => transaction_type,
        :requested_amount        => amount,
        :request_amount_currency => currency,
        :redirect_url            => success_redirect_url.html_safe,
        :ip_address              => customer_ip_address,
        :secret_key              => secret_key
      }
    end

    def customer_ip_address
      return "127.0.0.1" if Rails.env.development? # ::1 isn't accepted by UnionPay as IP
      user.last_sign_in_ip || "127.0.0.1"
    end

    def default_redirect_url
      "#{base_url}#{CONFIG[:default_redirect_url]}"
    end

    def cancel_redirect_url
      "#{base_url}#{CONFIG[:cancel_redirect_url]}"
    end

    def processing_redirect_url
      "#{base_url}#{CONFIG[:processing_redirect_url]}"
    end

    def success_redirect_url
      "#{base_url}#{CONFIG[:success_redirect_url]}"
    end

    def fail_redirect_url
      "#{base_url}#{CONFIG[:fail_redirect_url]}"
    end

    def digital_signature
      Digest::SHA256.hexdigest(signature_hash.values.join.squish)
    end

    def request_time_stamp
      @request_time_stamp ||= Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def valid_credentials?(credentials)
      credentials[:merchant_id] && credentials[:secret_key]
    end

  end
end
