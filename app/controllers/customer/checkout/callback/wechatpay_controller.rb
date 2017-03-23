class Customer::Checkout::Callback::WechatpayController < ApplicationController

  authorize_resource :class => false
  layout :default_layout

  def show
    # wechat doesn't transmit any data at this point
    flash[:success] = "Your order is being processed"
    redirect_to customer_orders_path
  end

end
