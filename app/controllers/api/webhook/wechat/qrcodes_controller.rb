require 'cgi'

# Get notifications from Wechat when the referrer Qrcode has been scanned
class Api::Webhook::Wechat::QrcodesController < Api::ApplicationController

  skip_before_filter :verify_authenticity_token

  attr_reader :transmit_data

  def index
    SlackDispatcher.new.message("QRCODE : #{request.body.read}")

        devlog.info "End of process."
        render status: :ok,
                json: {success: true}.to_json
  end

  def show
    SlackDispatcher.new.message("QRCODE : #{request.body.read}")

        devlog.info "End of process."
        render status: :ok,
                json: {success: true}.to_json
  end

  def create

    SlackDispatcher.new.message("QRCODE : #{request.body.read}")

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

    devlog.info "End of process."
    render status: :ok,
            json: {success: true}.to_json
  end

  # WARNING : Must stay public for throw_error to work well for now.
  def devlog
    @@devlog ||= Logger.new(Rails.root.join("log/wechatpay-customers-webhook-#{Time.now.strftime('%Y-%m-%d')}.log"))
  end

  private
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
