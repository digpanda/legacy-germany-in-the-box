require 'cgi'
require 'digest/sha1'

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

      # this is sent multiple times by the webhook, we protect multiple answers
      # we encrypt it beforehand for better processing / search / confidentiality
      if WebhookCache.cached?(cache_key)
        devlog.info('Data were already processed.')
        slack.message('Data were already processed.')
        return end_process
      else
        WebhookCache.create!(key: cache_key, section: :wechat)
      end

      # message handling
      if message?
        Notifier::Admin.new.new_wechat_message(user&.decorate&.who, content)
        slack.message "[Wechat] Service message from `#{user&.decorate&.who}` : `#{content}`"

        if content == '二维码'
          if user&.referrer
            # wechat forces us to use '.jpg' extension otherwise it considers the file as invalid format
            # NOTE : yes, they don't check MIME Type, no clue why.
            wechat_api_messenger.image(url: "#{guest_referrer_qrcode_url(user.referrer)}.jpg").send
          end
        end

        # test area for messages
        # if content == 'image'
        #   wechat_api_messenger.image(path: '/images/wechat/group.jpg').send
        # end
        #
        # if content == 'referrer'
        #   wechat_api_messenger.image(url: "#{guest_referrer_qrcode_url(Referrer.first)}.jpg").send
        # end

        # if content == 'rich'
        #   wechat_api_messenger.rich.add(
        #     title: 'Title 1',
        #     description: 'Description 1',
        #     url: 'http://mp.weixin.qq.com/s/Nm4NoP77dToKzXcQ1f0KVA',
        #     picture_url: 'https://www.germanyinbox.com/uploads/image/file/590064997302fc286f632711/8008001.jpg?e=1507641552&token=sjmi6rq8r6Z7oO84m9WQ3grXZJNaDmBlHC5eDWsu:zWT5_RgeYala8La0z00dYwVuaUY='
        #   ).add(
        #     title: 'Title 2',
        #     description: 'Description 2',
        #     url: 'https://mp.weixin.qq.com/s/ROTaqLJnvluHaWml0ud-3A',
        #     picture_url: 'https://www.germanyinbox.com/uploads/image/file/590064997302fc286f632711/8008001.jpg?e=1507641552&token=sjmi6rq8r6Z7oO84m9WQ3grXZJNaDmBlHC5eDWsu:zWT5_RgeYala8La0z00dYwVuaUY='
        #   ).send
        # end

        return end_process
      end

      # event handling
      case event
      when 'scan'
        handle_qrcode_callback
      when 'click'
        handle_menu_callback
      when 'subscribe'
        handle_subscribe_callback
      end

      return end_process
    end

    def end_process
      devlog.info 'End of process.'
      render text: 'success'
    end

    def handle_subscribe_callback
      if user
        welcome = "欢迎#{user.decorate.who}访问来因盒！"
      else
        welcome = '欢迎您访问来因盒'
      end
      wechat_api_messenger.text("""
      #{welcome}\n
      🎊德国精品: 来因盒首页，各类电商精品和海外服务汇总\n
      👔海外综合: 本地专业团队为您提供海外房产、金融投资、保险、医疗服务\n
      🙋聊客服下单: 直接跟客服聊天帮你下单\n\n\n
      ---购买下单注意事项---\n
      请填写收件人的收件地址，手机号(用于发货通知和快递员送货)，身份证号码(中国海关通关要求)\n
      微信内访问来因盒，首选微信支付一步完成。 支付宝需要拷贝粘贴支付宝链接到手机浏览器里完成支付\n
      所有商品阳光清关，包邮包税\n\n\n
      👑什么值得买: 一些欧洲、德国品牌为什么值得买\n\n\n
      🚚批发定制: 批发或定制产品采购请添加微信客服与我们联系\n
      ✅商业合作: 与来因盒平台进行商业合作请通过这里与我们联系\n
      """).send
    end

    def handle_menu_callback
      if event_key == 'coupon'
        wechat_api_messenger.text('2017a').send
      elsif event_key == 'wechatgroup'
        wechat_api_messenger.image(path: '/images/wechat/group.jpg').send
      elsif event_key == 'chatsale'
        wechat_api_messenger.text("""
        欢迎您通过微信客服聊天直接下单或者询问相关事宜。\n
        请扫来因盒微信号下面二维码或添加来因盒微信号:germanbox 也可以点击左下角小键盘直接留言。\n
        """).send
        wechat_api_messenger.image(path: '/images/wechat/wechat_support_qr.jpg').send
      elsif event_key == 'support'
        wechat_api_messenger.text("""
        欢迎您通过微信客服聊天直接下单或者询问相关事宜。\n
        请扫来因盒微信号下面二维码或添加来因盒微信号:germanbox 也可以点击左下角小键盘直接留言。\n
        📧客服邮箱: customer@germanyinthebox.com\n
        📞客服电话: 49-(0)89-21934711, 49-(0)89-21934727\n
        """).send
        wechat_api_messenger.image(path: '/images/wechat/wechat_support_qr.jpg').send
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

      if user && referrer
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
      @wechat_api_messenger_text ||= WechatApiMessenger.new(openid: openid)
    end

    def extra_data
      @extra_data ||= JSON.parse(event_key)
    end

    def user
      if wechat_user_solver.success?
        wechat_user_solver.data[:customer]
      end
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

    def cache_key
      @cache_key ||= Digest::SHA1.hexdigest("#{transmit_data}")
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
