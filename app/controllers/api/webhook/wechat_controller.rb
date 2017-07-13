require 'cgi'

# Get notifications from Wechat when the referrer Qrcode has been scanned
class Api::Webhook::WechatController < Api::ApplicationController


  # <xml><ToUserName><![CDATA[gh_c6ddf30d6707]]></ToUserName>
  # <FromUserName><![CDATA[oHb0TxCVMzCxEjCV2I-8wu9Z74Yk]]></FromUserName>
  # <CreateTime>1499777930</CreateTime>
  # <MsgType><![CDATA[event]]></MsgType>
  # <Event><![CDATA[SCAN]]></Event>
  # <EventKey><![CDATA[1172017]]></EventKey>
  # <Ticket><![CDATA[gQFN8DwAAAAAAAAAAS5odHRwOi8vd2VpeGluLnFxLmNvbS9xLzAyVS1EQ3d2dFpjajQxdGtKSk5wY0sAAgTVsmRZAwSAOgkA]]></Ticket>
  # </xml>

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
    @@devlog ||= Logger.new(Rails.root.join("log/wechat-webhook-#{Time.now.strftime('%Y-%m-%d')}.log"))
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
    SlackDispatcher.new.message("Raw params : #{transmit_data}")

    unless valid_json?(raw_extra_data)
      throw_api_error(:bad_format, {error: "Wrong extra_data transmitted"}, :bad_request)
      return
    end

    # we are in front of a referrer request
    referrer = Referrer.where(reference_id: extra_data["referrer"]["reference_id"]).first
    SlackDispatcher.new.message("Referrer is `#{referrer.id}`")

    if wechat_user_solver.success? && referrer
      user = wechat_user_solver.data[:customer]
      SlackDispatcher.new.message("Customer is `#{user.id}`")
    else
      SlackDispatcher.new.message("Customer was not resolved : #{wechat_user_solver.error}")
      throw_api_error(:bad_format, {error: "Wrong referrer or/and customer"}, :bad_request)
      return
    end

    unless user.parent_referred_at
      user.parent_referred_at = Time.now
      user.save
    end

    # protection if user has not already a parent_referrer
    if user.parent_referrer
      SlackDispatcher.new.message("User already got a referrer `#{user.parent_referrer.id}`")
    else
      # now we can safely bind them together
      referrer.children_users << user
      referrer.save
    end

    SlackDispatcher.new.message("Referrer user children `#{referrer.children_users.count}`")

    devlog.info "End of process."
    render status: :ok,
            json: {success: true}.to_json
  end

  def wechat_user_solver
    @wechat_user_solver ||= WechatUserSolver.new({provider: "wechat", openid: raw_openid}).resolve!
  end

  def extra_data
    @extra_data ||= JSON.parse(raw_extra_data)
  end

  def raw_extra_data
    transmit_data["EventKey"]
  end

  def raw_openid
    transmit_data["FromUserName"]
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
