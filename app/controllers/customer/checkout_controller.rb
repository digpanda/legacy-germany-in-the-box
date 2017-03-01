class Customer::CheckoutController < ApplicationController

  ACCEPTABLE_PAYMENT_METHOD = [:upop, :creditcard, :alipay, :wechatpay]

  attr_reader :shop, :order

  authorize_resource :class => false
  protect_from_forgery :except => [:success, :fail, :cancel, :processing]

  before_action :set_shop, :only => [:create]
  before_filter :ensure_session_order, :only => [:payment_method]
  before_filter :force_address_param, :only => [:create]

  before_action :breadcrumb_cart, :breadcrumb_checkout_address, :breadcrumb_payment_method

  before_action :freeze_header

  def create
    @order = cart_manager.order(shop: shop, call_api: false)
    current_address = current_user.addresses.find(params[:delivery_destination_id])
    checkout_ready = CheckoutReady.new(session, current_user, order, current_address).perform!

    if checkout_ready.success?
      redirect_to payment_method_customer_checkout_path
    else
      flash[:error] = checkout_ready.error
      redirect_to navigation.back(1)
    end
  end

  def payment_method
    @order = Order.find(session[:current_checkout_order])
    @shop = order.shop

    if order.bought?
      flash[:success] = I18n.t(:notice_order_already_paid, scope: :checkout)
      redirect_to customer_orders_path
      return
    end
  end

  def gateway
    order = Order.find(params[:order_id])
    payment_gateway = order.shop.payment_gateways.where(payment_method: params[:payment_method].to_sym).first

    unless payment_gateway
      flash[:error] = "Invalid payment gateway."
      redirect_to navigation.back(1)
      return
    end

    unless acceptable_payment_method?(payment_gateway.payment_method)
      flash[:error] = "Invalid payment method."
      redirect_to navigation.back(1)
      return
    end

    process_gateway(order, payment_gateway)
  end

  def process_gateway(order, payment_gateway)
    gateway = CheckoutGateway.new(root_url, current_user, order, payment_gateway)

    # we process differently depending the provider we use
    if payment_gateway.provider == :wirecard

      wirecard = gateway.wirecard

      # we will set a checkout variable for wirecard
      # because it goes through the front-end
      # NOTE : this could be adapted to any provider
      if wirecard.success?
        @checkout = wirecard[:checkout]
      else
        flash[:error] = wirecard.error
        redirect_to navigation.back(1)
      end

    elsif payment_gateway.provider == :alipay

      alipay = gateway.wirecard

      if alipay.success?
        redirect_to alipay[:url]
      else
        flash[:error] = alipay.error
        redirect_to navigation.back(1)
      end

    end
  end

  def acceptable_payment_method?(payment_method)
    ACCEPTABLE_PAYMENT_METHOD.include? payment_method
  end

  def success

    return unless callback!

    order_payment = OrderPayment.where(:request_id => params[:request_id]).first
    order = order_payment.order
    shop = order.shop

    StockManager.new(order).in_order!

    reset_shop_id_from_session(shop.id.to_s)
    order.coupon&.update(last_used_at: Time.now)

    # we manage the shipping details
    if order.logistic_partner == :borderguru
      BorderGuruApiHandler.new(order).calculate_and_get_shipping
    end

    # whatever happens with BorderGuru, if the payment is a success we consider
    # the transaction / order as successful, we will deal with BorderGuru through Slack / Emails
    flash[:success] = I18n.t(:checkout_ok, scope: :checkout)

    redirect_to customer_orders_path

  end

  # make the user return to the previous page
  def cancel
    redirect_to navigation.back(2)
    return
  end

  # alias of success
  def processing
    success
  end

  # the card processing failed
  def fail
    flash[:error] = I18n.t(:failed, scope: :payment)
    warn_developers(Wirecard::Base::Error.new, "Something went wrong during the payment.")
    return unless callback!(:failed)
    redirect_to navigation.back(2)
  end

  private

  # TODO: could be moved inside CurrentOrderHandler
  def reset_shop_id_from_session(shop_id)
    session[:order_shop_ids]&.delete(shop_id)
  end

  def callback!(forced_status=nil)

      customer_email = params["email"]

      if current_user.email != customer_email
        flash[:error] = I18n.t(:account_conflict, scope: :notice)
        redirect_to root_url
        return false
      end

      merchant_id = params["merchant_account_id"]
      request_id = params["request_id"]

      # COPIES FROM HERE
      order_payment = OrderPayment.where({merchant_id: merchant_id, request_id: request_id}).first
      WirecardPaymentChecker.new(params.symbolize_keys.merge({:order_payment => order_payment})).update_order_payment!

      order_payment.status = forced_status unless forced_status.nil? # TODO : improve this
      order_payment.save

      # if it's a success, it paid
      # we freeze the status to unverified for security reason
      # and the payment status freeze on unverified
      order_payment.order.refresh_status_from!(order_payment)
      # END OF COPY

      if order_payment.status == :success
        SlackDispatcher.new.paid_transaction(order_payment)
        prepare_notifications(order_payment)
      else
        SlackDispatcher.new.failed_transaction(order_payment)
      end

      true
  end

  def prepare_notifications(order_payment)
    order = order_payment.order
    DispatchNotification.new.perform_if_not_sent({
                                                                  order: order,
                                                                  user: order.shop.shopkeeper,
                                                                  title: "Auftrag #{order.id} am #{order.paid_at}",
                                                                  desc: 'Haben Sie die Bestellung schon vorbereiten? Senden Sie die bitte!'
                                                              })
    DispatchNotification.new.perform_if_not_selected_sent({
                                                                           order: order,
                                                                           user: order.shop.shopkeeper,
                                                                           title: "Auftrag #{order.id} am #{order.paid_at}",
                                                                           desc: "Haben Sie die Bestellung schon gesendet? Klicken Sie bitte 'Das Paket wurde versandt'"
                                                                       })
  end

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def set_order
    @order = Order.find(session[:current_checkout_order])
    @order = cart_manager.order(shop: @order.shop, call_api: false)
  end

  def force_address_param
    unless params[:delivery_destination_id]
      flash[:error] = "Please choose a delivery address."
      redirect_to navigation.back(1)
      return false
    end
    true
  end

  def ensure_session_order
    if session[:current_checkout_order].nil?
      redirect_to navigation.back(1)
      return false
    end
    true
  end

end
