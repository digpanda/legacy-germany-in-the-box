class WechatBot
  class Event < Base
    attr_reader :user, :event, :event_key

    def initialize(user, event, event_key)
      @user = user
      @event = event
      @event_key = event_key
    end

    def dispatch
      case event
      when 'scan'
        handle_qrcode_callback
      when 'click'
        handle_menu_callback
      when 'subscribe'
        handle_subscribe_callback
      end
    end

    def welcome_message
      if user
        "欢迎#{user.decorate.readable_who}访问来因盒！"
      else
        '欢迎您访问来因盒'
      end
    end

    def handle_subscribe_callback
      messenger.text("""
      #{welcome_message}\n
🎊德国精品: 来因盒首页，各类电商精品和海外服务汇总\n
👔海外综合: 本地专业团队为您提供海外房产、金融投资、保险、医疗服务\n
聊客服下单: 直接跟客服聊天帮你下单\n
---购买下单注意事项---\n
请填写收件人的收件地址，手机号(用于发货通知和快递员送货)，身份证号码(中国海关通关要求)\n
微信内访问来因盒，首选微信支付一步完成。 支付宝需要拷贝粘贴支付宝链接到手机浏览器里完成支付\n
所有商品阳光清关，包邮包税\n\n\n
--------------------\n
👑什么值得买: 一些欧洲、德国品牌为什么值得买\n\n\n
🚚批发定制: 批发或定制产品采购请添加微信客服与我们联系\n
✅商业合作: 与来因盒平台进行商业合作请通过这里与我们联系\n
""").send
    end

    def handle_menu_callback
      case event_key
      when 'offers'
        messenger.text('2017a').send
      when 'groupchat'
        messenger.image(path: '/images/wechat/group.jpg').send
      when 'chatsale'
        messenger.text("""
欢迎您通过微信客服聊天直接下单或者询问相关事宜。\n
请扫来因盒微信号下面二维码或添加来因盒微信号:germanbox 也可以点击左下角小键盘直接留言。\n
""").send
        messenger.image(path: '/images/wechat/wechat_support_qr.jpg').send
      when 'support'
        messenger.text("""
欢迎您通过微信客服联系下单及其他业务事宜。\n
请扫来因盒微信号下面二维码或添加来因盒微信号:germanbox 也可以点击左下角小键盘直接留言。\n
📧客服邮箱: customer@germanyinthebox.com\n
📞客服电话: 49-(0)89-21934711, 49-(0)89-21934727\n
""").send
        messenger.image(path: '/images/wechat/wechat_support_qr.jpg').send
      when 'ping'
        messenger.text('pong').send
      end
    end

    def handle_qrcode_callback
      unless Parser.valid_json?(event_key)
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

    def extra_data
      @extra_data ||= JSON.parse(event_key)
    end

  end
end
