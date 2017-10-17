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

      unless valid_xml?
        throw_api_error(:bad_format, { error: 'Wrong format transmitted' }, :bad_request)
        return
      end

      devlog.info("Raw params : #{transmit_data}")
      slack.message("Raw params : #{transmit_data}")

      slack.message ("MESSAGE ? #{message?}")
      if message?
        Notifier::Admin.new.new_wechat_message(content)
        slack.message "Sending message #{message} through email"
        render text: 'success'
        return
      end

      case event
      when 'scan'
        handle_qrcode_callback
      when 'click'
        handle_menu_callback
      when 'subscribe'
        handle_subscribe_callback
      end

      # case message
      # trigger email to admin
      # end

      devlog.info 'End of process.'
      render text: 'success'
    end

    def handle_subscribe_callback
      wechat_api_messenger.send """
      欢迎您访问来因盒\n
      🎊德国精品总览: 来因盒首页，各类电商精品和海外服务汇总\n
      👔海外综合服务: 本地专业团队为您提供海外房产、金融投资、保险、医疗服务\n
      🚚定制批量购买: 大单采购请和新品渠道开发需求请通过这里与我们联系\n
      ✅商业合作洽谈: 与来因盒平台进行商业合作请通过这里与我们联系\n
      👑德国精品故事: 一些欧洲、德国品牌为什么值得买\n
      """
    end

    def handle_menu_callback
      if event_key == 'coupon'
        wechat_api_messenger.send '2017a'
      elsif event_key == 'support'
        wechat_api_messenger.send """
        欢迎您通过微信和我们交流。\n
        请点击左下角小键盘直接留言，工作时间会在一小时内回复， 非工作时间会定期检查留言并回复。\n
        📧客服邮箱: customer@germanyinthebox.com\n
        📞客服电话: 49-(0)89-21934711, 49-(0)89-21934727\n
        """
      elsif event_key == 'usermanual'
        wechat_api_messenger.send  """
        ---购买下单注意事项---\n
        1. 将产品添加到购物车后点击手机屏幕右上方进入购物车下单\n
        2.\t请填写收件人的收件地址，手机号，身份证号码(中国海关通关要求)\n
        3.\t确定支付前，如果您有活动的打折码请输入打折码，并点击使用\n
        4.\t点击下单，在我的支付方式里选择付款方式并支付\n\n
        ---付款方式---\n
        来因盒支持在线支付宝和微信支付，购物费用均以人民币在线支付结算。\n
        通过微信访问来因盒，支付体验首选微信支付。 支付宝需要拷贝粘贴支付宝链接到手机浏览器里完成支付。\n\n
        ---来因盒产品价格---\n
        目前来因盒德国礼包的价格均为产品包邮，包税寄到您中国家里的价格\n\n
        ---海关关税---\n
        来因盒里的所有商品都从德国直接发货至国内，经阳光清关完税， 安全可靠。当前推广期内来因盒来替您缴付所有产品的关税。
        """
      end
    end

    def handle_qrcode_callback
      unless valid_json?(event_key)
        throw_api_error(:bad_format, { error: 'Wrong extra_data transmitted' }, :bad_request)
        return
      end

      # we are in front of a referrer request
      referrer = Referrer.where(reference_id: extra_data['referrer']['reference_id']).first
      slack.message "Referrer is `#{referrer.id}`", url: admin_referrer_url(referrer)

      if wechat_user_solver.success? && referrer
        user = wechat_user_solver.data[:customer]
        slack.message "Customer is `#{user.id}`", url: admin_user_url(user)
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
      @wechat_user_solver ||= WechatUserSolver.new(provider: :wechat, openid: openid).resolve
    end

    def wechat_api_messenger
      @wechat_api_messenger ||= WechatApiMessenger.new(openid: openid)
    end

    def extra_data
      @extra_data ||= JSON.parse(event_key)
    end

    def message?
      transmit_data['MsgType'] == 'text'
    end

    def content
      transmit_data['Content']
    end

    def event
      transmit_data['Event']&.downcase
    end

    def event_key
      transmit_data['EventKey']&.downcase
    end

    def openid
      transmit_data['FromUserName']
    end

    def valid_json?(json)
      JSON.parse(json)
      true
    rescue Exception
      false
    end

    def valid_xml?
      body
      true
    rescue REXML::ParseException
      false
    end

    def transmit_data
      @transmit_data ||= body&.[]('xml')
    end

    def body
      @body ||= Hash.from_xml(request.body.read)
    end

    def hook_activation?
      if params[:echostr]
        slack.message "[Webhook] Our Wechat Webhook is now verified / activated (echostr `#{params[:echostr]}`)."
        devlog.info 'End of process.'
        render text: "#{params[:echostr]}"
        true
      else
        false
      end
    end
end
