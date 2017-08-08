class Customer::Checkout::Callback::WechatpayController < ApplicationController
  authorize_resource class: false
  layout :default_layout

  def show
    # wechat doesn't transmit any data at this point
    flash[:success] = I18n.t(:processing, scope: :payment)
    redirect_to edit_customer_identity_path
  end

  # make the user return to the previous page
  def cancel
    redirect_to navigation.back(2)
  end

  # the card processing failed
  # NOTE : it can happen when someone didn't setup his wechatpay account
  # he has to choose another way.
  def fail
    flash[:error] = I18n.t(:failed, scope: :payment)
    redirect_to navigation.back(2)
  end
end
