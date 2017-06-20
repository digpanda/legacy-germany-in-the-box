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

  end
end
