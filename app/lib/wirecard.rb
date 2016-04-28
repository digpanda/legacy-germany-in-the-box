class Wirecard

  require 'net/http'
  require 'digest'

  attr_reader :merchant_id, :secret_key, :username, :password, :url

=begin

Request URL=https://sandbox-engine.thesolution.com/engine/hpp/
Request Method=POST
Status Code=302 Found Accept=text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8 Accept-Encoding=gzip, deflate
Accept-Language=en-US,en;q=0.8 Content-Type=application/x-www-form-urlencoded Host=sandbox-engine.thesolution.com

requested_amount:1.01
requested_amount_currency:CNY
locale:en
order_number:123456
order_detail:1 widget form_url:https://sandbox-engine.thesolution.com/engine/hpp/ request_id:ca077aff-b2e0-0e0b-3be2-08aa3b888b52 request_time_stamp:20160425212012 merchant_account_id:dfc3a296-3faf-4a1d-a075-f72f1b67dd2a payment_method:upop
transaction_type:debit redirect_url:https://sandbox-engine.thesolution.com/shop/complete.jsp?state=success& request_signature:723e75bfe0b730282a754c054389c09043e67e2bd75f96ff64f4939ceeaa09f6
psp_name:demo success_redirect_url:https://sandbox-engine.thesolution.com/shop/complete.jsp?state=success& fail_redirect_url:https://sandbox-engine.thesolution.com/shop/complete.jsp?state=failed& cancel_redirect_url:https://sandbox-engine.thesolution.com/shop/complete.jsp?state=cancel& processing_redirect_url:https://sandbox-engine.thesolution.com/shop/complete.jsp?state=processing& first_name:John
last_name:Doe
email:john.doe@wirecard.com
phone:1 555 555 5555
street1:123 test
street2:
city:Toronto
state:ON
postal_code:M4P1E8
country:CA
=end

  # https://hostname/engine/rest/merchants/{merchant-account-id}/payments/{transaction-id}
  # https://sandbox-engine.thesolution.com/engine/rest/merchants/dfc3a296-3faf-4a1d-a075-f72f1b67dd2a/payments/af3864e1-0b2b-11e6-9e82-00163e64ea9f

  def initialize(args={})
    @merchant_id ||= args[:merchant_id]
    @secret_key ||= args[:secret_key]
    @username ||= args[:username]
    @password ||= args[:password]
    @url = "https://sandbox-engine.thesolution.com/engine/hpp/"
  end

  def pay

    request = {:hey => "fuck"}
    response = Net::HTTP.post_form(URI.parse(url), request)

    binding.pry

  end

  def digital_signature(action='purchase', amount='1.01', currency='USD', redirect_url='')

    signature = {
      # WARNING : the order of the hash matters
      :request_time_stamp => unix_timestamp.to_s,
      :request_id =>'order-random78979',
      :merchant_account_id => merchant_id,
      :transaction_type => 'purchase',
      :requested_amount => amount,
      :request_amount_currency => currency,
      :redirect_url => redirect_url,
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

  end

  def unix_timestamp
    Time.now.to_i
  end


end