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
  end

  # WARNING : Must stay public for throw_error to work well for now.
  def devlog
    @@devlog ||= Logger.new(Rails.root.join("log/wechatpay-customers-webhook-#{Time.now.strftime('%Y-%m-%d')}.log"))
  end

  private

  def handle
    return if hook_activation?

    devlog.info "Wechat started to communicate with us ..."
    body = Hash.from_xml(request.body.read)
    @transmit_data = body&.[]("xml")

    unless valid_xml?
      throw_api_error(:bad_format, {error: "Wrong format transmitted"}, :bad_request)
      return
    end

    devlog.info("Raw params : #{transmit_data}")
    SlackDispatcher.new.message("PARAMS TRANSMIT : #{transmit_data}")

    extra_data = transmit_data["EventKey"]

    SlackDispatcher.new.message("EXTRA DATA #{extra_data}")

    if valid_json?(extra_data)
      extra_data = JSON.parse(extra_data)
    end

    SlackDispatcher.new.message("JSON AGAIN PARSED : #{extra_data}")

  end

  def valid_json?(json)
    JSON.parse(json)
    true
  rescue Exception
    false
  end

  def valid_xml?
    Hash.from_xml(request.body.read)
    true
  rescue REXML::ParseException
    false
  end

  def hook_activation?
    if params[:echostr]
      SlackDispatcher.new.message("[Webhook] Our Wechat Webhook is now verified / activated (echostr `#{params[:echostr]}`).")
      devlog.info "End of process."
      render text: params[:echostr]
      true
    else
      false
    end
  end

end
