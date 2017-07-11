require 'cgi'

# Get notifications from Wechat when the referrer Qrcode has been scanned
class Api::Webhook::WechatController < Api::ApplicationController

  skip_before_filter :verify_authenticity_token

  attr_reader :transmit_data

  def index
    handle
  end

  def show
    handle
  end

  def create
    handle

    # devlog.info "Wechatpay started to communicate with us ..."
    # body = Hash.from_xml(request.body.read)
    #
    # binding.pry
    #
    # @transmit_data = body&.[]("xml")
    #
    # unless valid_xml?
    #   throw_api_error(:bad_format, {error: "Wrong format transmitted"}, :bad_request)
    #   return
    # end
    #
    # devlog.info("Raw params : #{transmit_data}")
    #
    # if wrong_transmit_data?
    #   throw_api_error(:bad_format, {error: "Wrong transmit_datas transmitted"}, :bad_request)
    #   return
    # end
    #
    # if checkout_callback.success?
    #   devlog.info "Transaction successfully processed."
    #   SlackDispatcher.new.message("[Webhook] Wechatpay transaction SUCCESS processed : #{transmit_data}")
    # else
    #   devlog.info "Processing of the transaction failed."
    #   SlackDispatcher.new.message("[Webhook] Wechatpay transaction FAIL processed : #{transmit_data}")
    # end

  end

  # WARNING : Must stay public for throw_error to work well for now.
  def devlog
    @@devlog ||= Logger.new(Rails.root.join("log/wechatpay-customers-webhook-#{Time.now.strftime('%Y-%m-%d')}.log"))
  end

  private

  def handle

    if params[:echostr]
      SlackDispatcher.new.message("[Wechat] Our Webhook is now verified (echostr `#{params[:echostr]}`).")
      devlog.info "End of process."
      render text: params[:echostr]
      return
    end

    # {"signature"=>"cae5295df1dcbda69d56fe45a3559386172db163", "echostr"=>"17559559235148053755", "timestamp"=>"1499775155", "nonce"=>"988885973", "format"=>:json, "controller"=>"api/webhook/wechat/qrcodes", "action"=>"show"}
    SlackDispatcher.new.message("PARAMS: #{params}")
    SlackDispatcher.new.message("QRCODE : #{request.body.read}")
  end

  #
  # def checkout_callback
  #   @checkout_callback ||= CheckoutCallback.new(nil, cart_manager, transmit_data).wechatpay!
  # end
  #
  # def wrong_transmit_data?
  #   transmit_data["out_trade_no"].nil? || transmit_data["transaction_id"].nil? || transmit_data["return_code"].nil?
  # end
  #
  # def valid_xml?
  #   Hash.from_xml(request.body.read)
  #   true
  # rescue REXML::ParseException
  #   false
  # end

end
