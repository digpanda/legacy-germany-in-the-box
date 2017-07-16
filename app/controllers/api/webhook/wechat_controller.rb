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
    SlackDispatcher.new.message("[Webhook] Wechat Webhook was called.")

    devlog.info "Wechat started to communicate with us ..."
    body = Hash.from_xml(request.body.read)
    @transmit_data = body&.[]("xml")

    unless valid_xml?
      throw_api_error(:bad_format, {error: "Wrong format transmitted"}, :bad_request)
      return
    end

    devlog.info("Raw params : #{transmit_data}")
    SlackDispatcher.new.message("Raw params : #{transmit_data}")

    if event == "SCAN"
      SlackDispatcher.new.message("Event scan detected ...")
      handle_qrcode_callback!
    elsif event == "CLICK"
      SlackDispatcher.new.message("Event click detected ...")
      if raw_extra_data == "coupon"
        SlackDispatcher.new.message("Coupon event key.")
        render text: "2017a"
      elsif raw_extra_data == "support"
        SlackDispatcher.new.message("Support event key.")
        render text: "欢迎您通过微信和我们交流。\n请点击左下角小键盘直接留言，工作时间会在一小时内回复， 非工作时间会定期检查留言并回复。"
      elsif raw_extra_data == "buyerguide"
        SlackDispatcher.new.message("Buyer guide event key.")
        render text: "---购买下单注意事项---\n1. 将产品添加到购物车后点击手机屏幕右上方进入购物车下单\n2.\t请填写收件人的收件地址，手机号，身份证号码(中国海关通关要求)\n3.\t确定支付前，如果您有活动的打折码请输入打折码，并点击使用\n4.\t点击下单，在我的支付方式里选择付款方式并支付\n\n---付款方式---\n来因盒支持在线支付宝和微信支付，购物费用均以人民币在线支付结算。\n通过微信访问来因盒，支付体验首选微信支付。 支付宝需要拷贝粘贴支付宝链接到手机浏览器里完成支付。\n\n---来因盒产品价格---\n目前来因盒德国礼包的价格均为产品包邮，包税寄到您中国家里的价格\n\n---海关关税---\n来因盒里的所有商品都从德国直接发货至国内，经阳光清关完税， 安全可靠。当前推广期内来因盒来替您缴付所有产品的关税。"
      else
        render text: "success"
      end
    elsif event == "subscribe"
        SlackDispatcher.new.message("subscribe event.")
        render text: "欢迎访问来因盒！"
    else
        SlackDispatcher.new.message("default catcher all the rest.")
        render text: "success"
      return
    end

    devlog.info "End of process."
    render status: :ok,
            json: {success: true}.to_json
  end

  def handle_qrcode_callback!
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
    render text: "欢迎访问来因盒！"
  end

  def wechat_user_solver
    @wechat_user_solver ||= WechatUserSolver.new({provider: "wechat", openid: raw_openid}).resolve!
  end

  def extra_data
    @extra_data ||= JSON.parse(raw_extra_data)
  end

  def event
    transmit_data["Event"]
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
