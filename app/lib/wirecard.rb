class Wirecard

  require 'net/http'
  require 'digest'

  attr_reader :merchant_id, :secret_key, :username, :password, :url, :amount, :currency, :order_number, :order_detail, :request_time_stamp, :request_id, :redirect_url

  # https://hostname/engine/rest/merchants/{merchant-account-id}/payments/{transaction-id}
  # https://sandbox-engine.thesolution.com/engine/rest/merchants/dfc3a296-3faf-4a1d-a075-f72f1b67dd2a/payments/af3864e1-0b2b-11e6-9e82-00163e64ea9f

  def initialize(args={})
    @merchant_id ||= args[:merchant_id]
    @secret_key ||= args[:secret_key]
    @username ||= args[:username]
    @password ||= args[:password]
    @url = "https://sandbox-engine.thesolution.com/engine/hpp/"
    @amount ||= args[:amount].to_s
    @currency ||= args[:currency]
    @order_number ||= args[:order_number]
    @order_detail ||= args[:order_detail]
    @request_time_stamp ||= unix_timestamp
    @request_id ||= 'ca077aff-b2e0-0e0b-3be2-08aa3b888b52'
    @redirect_url ||= "https://sandbox-engine.thesolution.com/shop/complete.jsp"
  end

  # TODO : Refacto and abstract later on.
  def hosted_payment_request_datas
    
    {

      :requested_amount => amount,
      :requested_amount_currency => currency,
      :locale => 'en',
      :order_number => order_number,
      :order_detail => order_detail,
      :form_url => "https://sandbox-engine.thesolution.com/engine/hpp/",
      :request_id => request_id,
      :request_time_stamp => request_time_stamp,
      :merchant_account_id => merchant_id,
      :payment_method => "upop",
      :transaction_type => "debit",
      :redirect_url => "#{redirect_url}?state=success&",
      :request_signature => digital_signature,
      :psp_name => "demo",
      :success_redirect_url => "#{redirect_url}?state=success&",
      :fail_redirect_url => "#{redirect_url}?state=failed&",
      :cancel_redirect_url => "#{redirect_url}?state=cancel&",
      :processing_redirect_url => "#{redirect_url}?state=processing&",
      :first_name => "John",
      :last_name => "Doe",
      :email => "john.doe@wirecard.com",
      :phone => "1 555 555 5555",
      :street1 => "123 test",
      :street2 => "",
      :city => "Toronto",
      :state => "ON",
      :postal_code => "M4P1E8",
      :country => "CA"

    }

  end

  def digital_signature

    signature = {
      # WARNING : the order of the hash matters
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
    
    Digest::SHA256.hexdigest(signature.values.join)

=begin
request_time_stamp          = '20120430123012'
request_id                  = 'order-12345'
merchant_account_id         = 'b19fb056-d8da-449b-ac85-cfbfd0558914'
transaction_type            = 'purchase'
requested_amount            = '1.01'
requested_amount_currency   = 'USD'
redirect_url                = ''
ip_address                  = '127.0.0.1'
secret_key                  = 'efabf47b-e43b-4785-873f-1c5bc65b7cd2'
=end

# 20120430123012order-12345b19fb056-d8da-449b-ac85-cfbfd0558914purchase1.01USD127.0.0.1efabf47b-e43b-4785-873f-1c5bc65b7cd2

  end

  def unix_timestamp
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end


end