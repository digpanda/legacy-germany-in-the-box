class Customer::Checkout::Callback::AlipayController < ApplicationController

  authorize_resource :class => false
  layout :default_layout

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

  def show
    order = Order.where(id: params[:out_trade_no]).first
    unless order
      # impossible to find order
    end

    transaction_id = params[:trade_no]
    # paid_end_price = params[:total_fee]
    # status = params[:trade_status]

    # we refresh the bare minimum and wait the notification to verify the transaction itself
    # TODO : we should also check with the price and all
    order_payment = order.order_payments.where(status: :scheduled).first
    # TODO : maybe it's already verified so we go directly to the correct area depending the result ?
    order_payment.transaction_id = transaction_id

    unless success?
      order_payment.status = :failed
      order_payment.save

      flash[:error] = I18n.t(:failed, scope: :payment)
      # NOTE : we should replace wirecard error here
      warn_developers(Wirecard::Base::Error.new, "Something went wrong during the payment.")
      redirect_to navigation.back(2)
      return
    end

    order.status = :payment_unverified
    order.save
    order_payment.status = :unverified
    order_payment.save

    # whatever happens with BorderGuru, if the payment is a success we consider
    # the transaction / order as successful, we will deal with BorderGuru through Slack / Emails
    flash[:success] = I18n.t(:checkout_ok, scope: :checkout)

    redirect_to customer_orders_path

  end

  private

  def success?
    params[:is_success] == "T" ? true : false
  end

end
