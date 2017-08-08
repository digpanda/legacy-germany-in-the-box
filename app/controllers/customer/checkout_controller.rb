class Customer::CheckoutController < ApplicationController
  ACCEPTABLE_PAYMENT_METHOD = [:alipay, :wechatpay]

  attr_reader :shop, :order

  skip_before_filter :verify_authenticity_token
  authorize_resource class: false

  before_filter :ensure_session_order, only: [:payment_method, :gateway]
  before_action :set_order, only: [:create, :gateway, :payment_method]

  before_filter :force_address_param, only: [:create]

  before_action :breadcrumb_cart, :breadcrumb_checkout_address, :breadcrumb_payment_method

  before_action :freeze_header

  def create
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
    @shop = order.shop

    if order.bought?
      flash[:success] = I18n.t(:notice_order_already_paid, scope: :checkout)
      redirect_to customer_orders_path
      return
    end
  end

  def gateway
    unless params[:payment_method]
      flash[:error] = 'Invalid payment method.'
      redirect_to navigation.back(1)
      return
    end

    payment_gateway = order.shop.payment_gateways.where(payment_method: params[:payment_method].to_sym).first

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

    checkout_gateway = CheckoutGateway.new(request, current_user, order, payment_gateway, identity_solver).perform
    # we process differently depending the provider we use
    # if it contains `page` we render the page
    # otherwise you redirect to the `url`
    if checkout_gateway.success?
      if checkout_gateway.data[:page]
        @checkout = checkout_gateway.data[:page]
        render "customer/checkout/gateway/#{payment_gateway.provider}"
        return
      end

      if checkout_gateway.data[:url]
        redirect_to checkout_gateway.data[:url]
        return
      end
    end

    flash[:error] = checkout_gateway.error
    redirect_to navigation.back(1)
  end

  private

    def acceptable_payment_method?(payment_method)
      ACCEPTABLE_PAYMENT_METHOD.include? payment_method
    end

    def set_order
      @order = Order.find(session[:current_checkout_order])
    end

    def force_address_param
      unless params[:delivery_destination_id]
        flash[:error] = '请选择邮寄地址'
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
