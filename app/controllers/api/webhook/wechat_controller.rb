require 'cgi'

# Get notifications from Wechat when the referrer Qrcode has been scanned
class Api::Webhook::WechatController < Api::ApplicationController
  attr_reader :transmit_data

  skip_before_filter :verify_authenticity_token

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

    # <xml><ToUserName><![CDATA[gh_c6ddf30d6707]]></ToUserName>
    # <FromUserName><![CDATA[oHb0TxCVMzCxEjCV2I-8wu9Z74Yk]]></FromUserName>
    # <CreateTime>1499777930</CreateTime>
    # <MsgType><![CDATA[event]]></MsgType>
    # <Event><![CDATA[SCAN]]></Event>
    # <EventKey><![CDATA[1172017]]></EventKey>
    # <Ticket><![CDATA[gQFN8DwAAAAAAAAAAS5odHRwOi8vd2VpeGluLnFxLmNvbS9xLzAyVS1EQ3d2dFpjajQxdGtKSk5wY0sAAgTVsmRZAwSAOgkA]]></Ticket>
    # </xml>
    def handle
      return if hook_activation?
      # slack.message '[Webhook] Wechat Webhook was called.'

      devlog.info 'Wechat started to communicate with us ...'
      body = Hash.from_xml(request.body.read)
      @transmit_data = body&.[]('xml')

      unless valid_xml?
        throw_api_error(:bad_format, { error: 'Wrong format transmitted' }, :bad_request)
        return
      end

      devlog.info("Raw params : #{transmit_data}")
      # slack.message("Raw params : #{transmit_data}")

      if event == 'SCAN'
        handle_qrcode_callback!
        render text: 'success'
        return
      elsif event == 'CLICK'
        if raw_extra_data == 'coupon'
          render text: '2017a'
        elsif raw_extra_data == 'support'
          render text: '欢迎您通过微信和我们交流。\n请点击左下角小键盘直接留言，工作时间会在一小时内回复， 非工作时间会定期检查留言并回复。'
        elsif raw_extra_data == 'buyerguide'
          render text: '---购买下单注意事项---\n1. 将产品添加到购物车后点击手机屏幕右上方进入购物车下单\n2.\t请填写收件人的收件地址，手机号，身份证号码(中国海关通关要求)\n3.\t确定支付前，如果您有活动的打折码请输入打折码，并点击使用\n4.\t点击下单，在我的支付方式里选择付款方式并支付\n\n---付款方式---\n来因盒支持在线支付宝和微信支付，购物费用均以人民币在线支付结算。\n通过微信访问来因盒，支付体验首选微信支付。 支付宝需要拷贝粘贴支付宝链接到手机浏览器里完成支付。\n\n---来因盒产品价格---\n目前来因盒德国礼包的价格均为产品包邮，包税寄到您中国家里的价格\n\n---海关关税---\n来因盒里的所有商品都从德国直接发货至国内，经阳光清关完税， 安全可靠。当前推广期内来因盒来替您缴付所有产品的关税。'
        else
          render text: 'success'
        end
        return
      elsif event == 'subscribe'
        render text: 'success'
        return
      else
        render text: 'success'
        return
      end

      devlog.info 'End of process.'
      render status: :ok,
      json: { success: true }.to_json
    end

    def handle_qrcode_callback!
      unless valid_json?(raw_extra_data)
        throw_api_error(:bad_format, { error: 'Wrong extra_data transmitted' }, :bad_request)
        return
      end

      # we are in front of a referrer request
      referrer = Referrer.where(reference_id: extra_data['referrer']['reference_id']).first
      slack.message "Referrer is `#{referrer.id}`", url: admin_referrer_path(referrer)

      if wechat_user_solver.success? && referrer
        user = wechat_user_solver.data[:customer]
        slack.message "Customer is `#{user.id}`", url: admin_user_path(user)
      else
        slack.message "Customer was not resolved : #{wechat_user_solver.error}"
        throw_api_error(:bad_format, { error: 'Wrong referrer or/and customer' }, :bad_request)
        return
      end

      # binding the potential user with the referrer
      ReferrerBinding.new(referrer).bind(user)

      slack.message "Referrer user children `#{referrer.children_users.count}`"
    end

    def wechat_user_solver
      @wechat_user_solver ||= WechatUserSolver.new(provider: 'wechat', openid: raw_openid).resolve!
    end

    def extra_data
      @extra_data ||= JSON.parse(raw_extra_data)
    end

    def event
      transmit_data['Event']
    end

    def raw_extra_data
      transmit_data['EventKey']
    end

    def raw_openid
      transmit_data['FromUserName']
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
        slack.message "[Webhook] Our Wechat Webhook is now verified / activated (echostr `#{params[:echostr]}`)."
        devlog.info 'End of process.'
        render text: params[:echostr]
        true
      else
        false
      end
    end
end
