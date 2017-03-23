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
    prepare_order_payment!
    process!
  end

  private

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

  def unified_order
    @unified_order ||= WxPay::Service.invoke_unifiedorder({
      body: "Order #{order.id}",
      out_trade_no: "#{order.id}",
      total_fee: 1, # total_fee,
      spbill_create_ip: '127.0.0.1',
      notify_url: "#{base_url}#{new_api_webhook_wechatpay_customer_path}",
      trade_type: 'JSAPI', # 'JSAPI', # could be "JSAPI", "NATIVE" or "APP",
      openid: openid # Laurent's openid
    })
  end

  def javascript_pay_request
    @javascript_pay_request ||= WxPay::Service.generate_js_pay_req({
      prepayid: unified_order["prepay_id"],
      noncestr: unified_order["nonce_str"]
    })
  end

  def process!
    SlackDispatcher.new.message(    {
          unified_order: unified_order,
          javascript_pay_request: javascript_pay_request
        })
    {
      unified_order: unified_order,
      javascript_pay_request: javascript_pay_request
    }
  end

  def total_fee
    (order.end_price.in_euro.to_yuan.amount * 100).to_i
  end

  def openid
    if Rails.env.production?
      wechat_openid
    else
      'oKhjVvoKBlhnV5lBTQQdSI7sd0Tg' # Laurent's openid which was authorized in Wechatpay Dashboard
    end
  end

  # NOTE : this is a copy of alipay checkout (below) ; we should refactor it

  # we either match an exact equivalent order payment which means
  # we already tried to pay but failed at any point of the process
  # before the `:scheduled` status changed
  def order_payment
    @order_payment ||= (recovered_order_payment || OrderPayment.new)
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
    order_payment.tap do |order_payment|
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
