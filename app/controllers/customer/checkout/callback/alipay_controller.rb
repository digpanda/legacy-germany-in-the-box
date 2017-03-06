class Customer::Checkout::Callback::AlipayController < ApplicationController

  authorize_resource :class => false
  layout :default_layout

  def show

    checkout = checkout_callback.alipay!(mode: :unsafe)
    unless checkout.success?
      SlackDispatcher.new.message("Error checkout callback #{checkout_callback.error}")
      flash[:error] = checkout.error
      redirect_to navigation.back(2)
      return
    end

    order = Order.where(id: params[:out_trade_no]).first
    checkout_callback.manage_stocks!(order, cart_manager)
    checkout_callback.manage_logistic!(order)
    flash[:success] = I18n.t(:checkout_ok, scope: :checkout)

    redirect_to customer_orders_path

  end

  def checkout_callback
    @checkout_callback ||= CheckoutCallback.new(current_user, params)
  end

end
