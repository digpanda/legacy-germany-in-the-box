class Customer::Checkout::Callback::WirecardController < ApplicationController

  authorize_resource :class => false
  layout :default_layout
  protect_from_forgery :except => [:success, :fail, :cancel, :processing]

  def success
    callback = checkout_callback.wirecard!
    unless callback.success?
      SlackDispatcher.new.message("[Exception] Error checkout callback #{callback.error}")
      flash[:error] = callback.error
      redirect_to navigation.back(2)
      return
    end

    flash[:success] = I18n.t(:checkout_ok, scope: :checkout)
    redirect_to edit_customer_identity_path
  end

  # make the user return to the previous page
  def cancel
    redirect_to navigation.back(1)
  end

  # alias of success
  def processing
    success
  end

  # the card processing failed
  def fail
    flash[:error] = I18n.t(:failed, scope: :payment)

    callback = CheckoutCallback.new(current_user, cart_manager, params, :failed).wirecard!
    unless callback.success?
      SlackDispatcher.new.message("[Exception] Error checkout callback #{callback.error}")
      flash[:error] = callback.error
    end

    redirect_to navigation.back(1)
  end

  private

  def checkout_callback(forced_status: nil)
    @checkout_callback ||= CheckoutCallback.new(current_user, cart_manager, params)
  end

end
