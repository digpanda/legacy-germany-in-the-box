class CheckoutCallback < BaseService

  # {"sign"=>"0ba0871c3777191fda758b07189a59c3",
  #  "trade_no"=>"2017030821001003840200345741",
  #  "total_fee"=>"1262.41",
  #  "sign_type"=>"MD5",
  #  "out_trade_no"=>"58bfc16af54bcc0a0b908c44",
  #  "trade_status"=>"TRADE_FINISHED",
  #  "currency"=>"HKD",
  #  "controller"=>"customer/checkout/callback/alipay",
  #  "action"=>"show"}

  include ErrorsHelper

  attr_reader :user, :params, :forced_status

  # NOTE : the forced status isn't currently working with alipay
  def initialize(user, params, forced_status=nil)
    @user = user
    @params = params
    @forced_status = forced_status
  end

  def wirecard!
    if user.email != params["email"]
      return return_with(:error, I18n.t(:account_conflict, scope: :notice))
    end

    order_payment = solve_wirecard_order_payment_and_refresh!
    dispatch_notifications!(order_payment)

    return_with(:success)
  end

  def alipay!(mode: :unsafe)

    order = Order.where(id: params[:out_trade_no]).first
    unless order
      return return_with(:error, "Order not found from the AliPay callback")
    end

    transaction_id = params[:trade_no]
    # paid_end_price = params[:total_fee]
    # status = params[:trade_status]

    # we refresh the bare minimum and wait the notification to verify the transaction itself
    order_payment = (OrderPayment.where(transaction_id: transaction_id).first || order.order_payments.where(status: :scheduled).first)
    order_payment.transaction_id = transaction_id

    unless alipay_success?(mode)
      order_payment.status = :failed
      order_payment.save
      order_payment.order.refresh_status_from!(order_payment)
      warn_developers(Wirecard::Base::Error.new, "Something went wrong during the payment.")
      return return_with(:error, I18n.t(:failed, scope: :payment))
    end

    if mode == :unsafe

      # we come from a normal callback so we are not sure
      # about the validity of those data
      order_payment.status = :unverified
      order_payment.save
      order_payment.order.refresh_status_from!(order_payment)
      # we dispatch the notification anyway
      dispatch_notifications!(order_payment)

    elsif mode == :safe

      # The status is success and the communication is safe
      order_payment.status = :success
      order_payment.save
      order_payment.order.refresh_status_from!(order_payment)

    else
      return return_with(:error, "Mode for Alipay callback unknown")
    end

    return return_with(:success)
  end

  def manage_stocks!(order, cart_manager)
    StockManager.new(order).in_order!
    cart_manager.empty!
    order.coupon&.update(last_used_at: Time.now)
  end

  def manage_logistic!(order)
    if order.logistic_partner == :borderguru
      BorderGuruApiHandler.new(order).calculate_and_get_shipping
    end
  end

  private

  def alipay_success?(mode)
    params[:trade_status] == "TRADE_FINISHED" ? true : false
    # if mode == :unsafe
    #   params[:trade_status] == "TRADE_FINISHED" ? true : false
    # elsif mode == :safe
    #   params[:trade_status] == "TRADE_SUCCESS" ? true : false
    # else
    #   false
    # end
  end

  def solve_wirecard_order_payment_and_refresh!
    OrderPayment.where({merchant_id: params[:merchant_account_id], request_id: params[:request_id]}).first.tap do |order_payment|
      # we check WireCard API which makes it safe
      # so we can change the status itself
      # NOTE : we shouldn't do it for anything else
      WirecardPaymentChecker.new(params.symbolize_keys.merge({:order_payment => order_payment})).update_order_payment!
      order_payment.status = forced_status if forced_status
      order_payment.save
      order_payment.order.refresh_status_from!(order_payment)
    end
  end

  def dispatch_notifications!(order_payment)
    if order_payment.status == :success
      SlackDispatcher.new.paid_transaction(order_payment)

      DispatchNotification.new.perform_if_not_sent({
        order: order_payment.order,
        user: order_payment.order.shop.shopkeeper,
        title: "Auftrag #{order_payment.order.id} am #{order_payment.order.paid_at}",
        desc: 'Haben Sie die Bestellung schon vorbereiten? Senden Sie die bitte!'
        })
      DispatchNotification.new.perform_if_not_selected_sent({
        order: order_payment.order,
        user: order_payment.order.shop.shopkeeper,
        title: "Auftrag #{order_payment.order.id} am #{order_payment.order.paid_at}",
        desc: "Haben Sie die Bestellung schon gesendet? Klicken Sie bitte 'Das Paket wurde versandt'"
        })

    else
      SlackDispatcher.new.failed_transaction(order_payment)
    end
  end



end
