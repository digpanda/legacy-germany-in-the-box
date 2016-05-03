module Wirecard
  class Customer

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
                :redirect_url

    def initialize(user, args={})

      @user = user
      @merchant_id ||= args[:merchant_id]
      @secret_key ||= args[:secret_key]
      @amount ||= args[:amount].to_s
      @currency ||= args[:currency]
      @order_number ||= args[:order_number]
      @order_detail ||= args[:order_detail]
      @request_time_stamp ||= timestamp
      @request_id ||= [timestamp, user.id, order_number].join('-')
      @hosted_payment_url = ::Rails.application.config.wirecard["customers"]["hosted_payment_url"]
      @redirect_url ||= ::Rails.application.config.wirecard["customers"]["redirect_url"]

    end

    def hosted_payment_datas

      {
        :requested_amount => amount,
        :requested_amount_currency => currency,
        :locale => 'en',
        :order_number => order_number,
        :order_detail => order_detail,
        :form_url => hosted_payment_url,
        :request_id => request_id,
        :request_time_stamp => request_time_stamp,
        :merchant_account_id => merchant_id,
        :payment_method => "upop",
        :transaction_type => "debit",
        :redirect_url => "#{redirect_url}?state=success&".html_safe,
        :request_signature => digital_signature,
        :psp_name => "demo",
        :success_redirect_url => "#{redirect_url}?state=success&".html_safe,
        :fail_redirect_url => "#{redirect_url}?state=failed&".html_safe,
        :cancel_redirect_url => "#{redirect_url}?state=cancel&".html_safe,
        :processing_redirect_url => "#{redirect_url}?state=processing&".html_safe,

        :first_name => user.fname,
        :last_name => user.lname,
        :email => user.email,
        :phone => user.tel,
        :street1 => "123 test",
        :street2 => "",
        :city => "Toronto",
        :state => "ON",
        :postal_code => "M4P1E8",
        :country => "CA",
        :ip_address => "127.0.0.1"
      }

    end

    def digital_signature

      # WARNING : the order of the hash matters
      signature = {
      :request_time_stamp => request_time_stamp,
      :request_id => request_id,
      :merchant_account_id => merchant_id,
      :transaction_type => "debit",
      :requested_amount => amount,
      :request_amount_currency => currency,
      :redirect_url => "#{redirect_url}?state=success&",
      :ip_address => '127.0.0.1',
      :secret_key => secret_key
      }

      Digest::SHA256.hexdigest(signature.values.join.squish)

    end

    def timestamp
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

  end
end