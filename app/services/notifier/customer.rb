class Notifier
  class Customer < Notifier

    attr_reader :user

    def initialize(user)
      @user = user
    end

    def welcome
      dispatch(
        title: '注册成功，欢迎光临来因盒！',
        desc: "亲，欢迎你到来因盒购物。"
      ).perform
    end

    def order_was_paid(order)
      dispatch(
        title: "来因盒通知：付款成功，已通知商家准备发货 （订单号：#{order.id})",
        desc: "你好，你的订单#{order.id}已成功付款，已通知商家准备发货。若有疑问，欢迎随时联系来因盒客服：user@germanyinthebox.com。"
      ).perform
    end

    def order_is_being_processed(order)
      dispatch(
        title: '你的订单已出货',
        desc: "你的订单已被商家寄出"
      ).perform
    end

    def referrer_provision_was_raised(order_payment, referrer, referrer_provision)
      dispatch(
        title: "一位客户",
        desc: "顾客#{order_payment.order.shipping_address.decorate.chinese_full_name}在您的推荐下在来因盒平台下了一个#{order_payment.amount_eur.in_euro.display}的订单。您现在的总佣金为#{referrer.total_earned.in_euro.display} (订单佣金 +#{referrer_provision.provision.in_euro.display})"
      ).perform(dispatch: [:sms])
    end

    def order_has_been_shipped(order)
      dispatch(
        title: "发货通知",
        desc: "亲爱的顾客，您的订单#{order.id}已安排发货。快递单号为：#{order.tracking_id}，您可登陆快递100http://www.kuaidi100.com 查询快递状态。"
      ).perform(dispatch: [:sms])
    end

  end
end
