require 'cgi'

# Get notifications from Alipay when a transaction has been done
class Api::Webhook::Alipay::CustomersController < Api::ApplicationController
  skip_before_filter :verify_authenticity_token

  # {"discount"=>"0.00",
  #  "payment_type"=>"1",
  #  "subject"=>"Order 58bbe2e6f54bcc042b42e9ea",
  #  "trade_no"=>"2017030521001004840200342628",
  #  "buyer_email"=>"douyufua@alitest.com",
  #  "gmt_create"=>"2017-03-05 18:06:49",
  #  "notify_type"=>"trade_status_sync",
  #  "quantity"=>"1",
  #  'out_trade_no'=>"58bbe2e6f54bcc042b42e9ea",
  #  "seller_id"=>"2088101122136241",
  #  "notify_time"=>"2017-03-05 18:21:11",
  #  "trade_status"=>"TRADE_SUCCESS",
  #  "is_total_fee_adjust"=>"N",
  #  "total_fee"=>"793.36",
  #  "gmt_payment"=>"2017-03-05 18:17:17",
  #  "seller_email"=>"overseas_kgtest@163.com",
  #  "price"=>"793.36",
  #  "buyer_id"=>"2088102140176848",
  #  "notify_id"=>"39863b44e9bf2e9877a57ef5451a717mhe",
  #  "use_coupon"=>"N",
  #  "sign_type"=>"MD5",
  #  "sign"=>"c8215a718439aec25cf8051730bf459a",
  #  "format"=>:json,
  #  "controller"=>"api/webhook/alipay/customers",
  #  "action"=>"create"}

  def create
    devlog.info 'Alipay started to communicate with us ...'
    devlog.info("Raw params : #{params}")

    if wrong_params?
      throw_api_error(:bad_format, { error: 'Wrong datas transmitted' }, :bad_request)
      return
    end

    if checkout_callback.success?
      devlog.info 'Transaction successfully processed.'
      SlackDispatcher.new.message("[Webhook] Alipay transaction SUCCESS processed : #{params}")
    else
      devlog.info 'Processing of the transaction failed.'
      SlackDispatcher.new.message("[Webhook] Alipay transaction FAIL processed : #{params}")
    end

    devlog.info 'End of process.'
    render status: :ok,
            json: { success: true }.to_json
  end

  # WARNING : Must stay public for throw_error to work well for now.
  def devlog
    @@devlog ||= Logger.new(Rails.root.join("log/alipay-customers-webhook-#{Time.now.strftime('%Y-%m-%d')}.log"))
  end

  private

    def checkout_callback
      @checkout_callback ||= CheckoutCallback.new(nil, cart_manager, params).alipay!(mode: :safe)
    end

    def wrong_params?
      params[:trade_no].nil? || params[:out_trade_no].nil? || params[:trade_status].nil?
    end
end
