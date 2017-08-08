class Customer::Checkout::Callback::AlipayController < ApplicationController
  authorize_resource class: false
  layout :default_layout

  def show
    checkout = checkout_callback.alipay!(mode: :unsafe)
    unless checkout.success?
      slack.message("[Exception] Error checkout callback #{checkout.error}")
      flash[:error] = checkout.error
      redirect_to navigation.back(2)
      return
    end

    flash[:success] = I18n.t(:checkout_ok, scope: :checkout)
    redirect_to edit_customer_identity_path
  end

  private

    def checkout_callback
      @checkout_callback ||= CheckoutCallback.new(current_user, cart_manager, params)
    end
end
