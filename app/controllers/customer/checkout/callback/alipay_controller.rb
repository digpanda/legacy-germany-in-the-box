class Customer::Checkout::Callback::AlipayController < ApplicationController

  authorize_resource :class => false
  layout :default_layout

  def show

    order = Order.where(id: params[:out_trade_no]).first
    unless order
      # impossible to find order
    end

    transaction_id = params[:trade_no]
    paid_end_price = params[:total_fee]
    status = params[:trade_status]

    # "buyer_email"=>"douyufua@alitest.com",
    #  "buyer_id"=>"2088102140176848",
    #  "exterface"=>"create_direct_pay_by_user",
    #  "is_success"=>"T",
    #  "notify_id"=>"RqPnCoPT3K9%2Fvwbh3InZezKlMxllK3E5ZD7DWVjMqU7uv%2F%2B9DRu6hB5xgojPf166FLG3",
    #  "notify_time"=>"2017-03-03 18:51:44",
    #  "notify_type"=>"trade_status_sync",
    #  "out_trade_no"=>"58b94a9df54bcc042b42e9a5",
    #  "payment_type"=>"1",
    #  "seller_email"=>"overseas_kgtest@163.com",
    #  "seller_id"=>"2088101122136241",
    #  "subject"=>"Order 58b94a9df54bcc042b42e9a5",
    #  "total_fee"=>"2228.24",
    #  "trade_no"=>"2017030321001004840200341035",
    #  "trade_status"=>"TRADE_SUCCESS",
    #  "sign"=>"40c332bf53e6bb736d979d9203d2c14c",
    #  "sign_type"=>"MD5",
    #  "controller"=>"customer/checkout/callback/alipay",
    #  "action"=>"show"}

    binding.pry
  end

end
