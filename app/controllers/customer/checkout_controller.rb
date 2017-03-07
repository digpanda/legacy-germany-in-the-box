class Customer::CheckoutController < ApplicationController

  ACCEPTABLE_PAYMENT_METHOD = [:upop, :creditcard, :alipay, :wechatpay]

  attr_reader :shop, :order

  authorize_resource :class => false

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
    order = Order.where(id: params[:order_id]).first
    payment_gateway = order.shop.payment_gateways.where(payment_method: params[:payment_method].to_sym).first

    unless order
      flash[:error] = I18n.t(:invalid_order, scope: :edit_order)
      redirect_to navigation.back(1)
      return
    end

    unless payment_gateway
      flash[:error] = I18n.t(:invalid_gateway, scope: :edit_order)
      redirect_to navigation.back(1)
      return
    end

    unless acceptable_payment_method?(payment_gateway.payment_method)
      flash[:error] = I18n.t(:invalid_payment_method, scope: :edit_order)
      redirect_to navigation.back(1)
      return
    end

    checkout_gateway = CheckoutGateway.new(request, current_user, order, payment_gateway).perform
    # we process differently depending the provider we use
    # if it contains `page` we render the page
    # otherwise you redirect to the `url`
    if checkout_gateway.success?
      if checkout_gateway.data[:page]
        @checkout = checkout_gateway.data[:page]
      elsif checkout_gateway.data[:url]
        redirect_to checkout_gateway.data[:url]
      end
      return
    end

    flash[:error] = checkout_gateway.error
    redirect_to navigation.back(1)
  end

  private

  def acceptable_payment_method?(payment_method)
    ACCEPTABLE_PAYMENT_METHOD.include? payment_method
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
