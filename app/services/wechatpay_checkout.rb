# prepare an order to be transmitted to the Alipay server
class WechatpayCheckout < BaseService

  include Rails.application.routes.url_helpers

  attr_reader :base_url, :user, :order, :payment_gateway, :identity_solver

  def initialize(base_url, user, order, payment_gateway, identity_solver)
    @base_url = base_url
    @user  = user
    @order = order
    @payment_gateway = payment_gateway
    @identity_solver = identity_solver
  end

  # we access the Wirecard::Hpp library and generate the needed datas
  # make a new OrderPayment linked to the request which we will manipulate later on
  def checkout!
    #prepare_order_payment!
    process!
  end

  private

  def process!

    unifiedorder = WxPay::Service.invoke_unifiedorder({
      body: "Order #{order.id}",
      out_trade_no: "#{order.id}",
      total_fee: 1, # "#{order.end_price.in_euro.to_yuan.display_raw}",
      spbill_create_ip: '127.0.0.1',
      notify_url: "#{base_url}#{new_api_webhook_wechatpay_customer_path}",
      trade_type: 'JSAPI', # 'JSAPI', # could be "JSAPI", "NATIVE" or "APP",
      openid: 'oKhjVvuA9bhRwpsvDqAHRsCAgxUU'
    })

    # {"xml"=>
    #     {"return_code"=>"SUCCESS",
    #      "return_msg"=>"OK",
    #      "appid"=>"wxfde44fe60674ba13",
    #      "mch_id"=>"1354063202",
    #      "nonce_str"=>"cvTr8zN4EU4RTvFt",
    #      "sign"=>"5F7FB422CC25A8B8287EA8AF99E8D192",
    #      "result_code"=>"SUCCESS",
    #      "prepay_id"=>"wx201703161727381d0112c4620476236953",
    #      "trade_type"=>"JSAPI"}},
    #  "return_code"=>"SUCCESS",
    #  "return_msg"=>"OK",
    #  "appid"=>"wxfde44fe60674ba13",
    #  "mch_id"=>"1354063202",
    #  "nonce_str"=>"cvTr8zN4EU4RTvFt",
    #  "sign"=>"5F7FB422CC25A8B8287EA8AF99E8D192",
    #  "result_code"=>"SUCCESS",
    #  "prepay_id"=>"wx201703161727381d0112c4620476236953",
    #  "trade_type"=>"JSAPI"}

    result = unifiedorder[:raw]["xml"]

    SlackDispatcher.new.message("WECHATPAY RESULT : #{result}")

    if result["result_code"] != "SUCCESS"
      # There were a problem
      SlackDispatcher.new.message("It didn't work.")
    end

    result = WxPay::Service.generate_js_pay_req({
      prepayid: result["prepay_id"],
      noncestr: result["nonce_str"]
    })

    SlackDispatcher.new.message("WECHATPAY JS PAY REQUEST : #{result}")

    # {:appId=>"wxfde44fe60674ba13", :package=>"prepay_id=wx201703161727381d0112c4620476236953", :nonceStr=>"cvTr8zN4EU4RTvFt", :timeStamp=>"1489656458", :signType=>"MD5", :paySign=>"9268392B59318E960E8E88A0C82E9681"}

    #binding.pry

  end

  # NOTE : this is a copy of alipay checkout (below) ; we should refactor it

  # we either match an exact equivalent order payment which means
  # we already tried to pay but failed at any point of the process
  # before the `:scheduled` status changed
  def matching_order_payment
    @matching_order_payment ||= (recovered_order_payment || OrderPayment.new)
  end

  # may return nil
  def recovered_order_payment
    OrderPayment.where({
      :order_id         => order.id,
      :status           => :scheduled,
      :user_id          => user.id
    }).first
  end

  def prepare_order_payment!
    matching_order_payment.tap do |order_payment|
      order_payment.user_id          = user.id
      order_payment.order_id         = order.id
      order_payment.status           = :scheduled
      order_payment.payment_method   = :wechatpay
      order_payment.transaction_type = :debit
      order_payment.save
      order_payment.save_origin_amount!(order.end_price.in_euro.to_yuan.amount, "CNY")
      order_payment.refresh_currency_amounts!
    end
  end

end
