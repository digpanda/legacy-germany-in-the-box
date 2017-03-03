class Customer::Checkout::Callback::WirecardController < ApplicationController

  authorize_resource :class => false
  layout :default_layout
  protect_from_forgery :except => [:success, :fail, :cancel, :processing]

  def success

    return unless CheckoutCallback.new(current_user, params).wirecard!.success?

    order_payment = OrderPayment.where(:request_id => params[:request_id]).first
    order = order_payment.order

    StockManager.new(order).in_order!
    cart_manager.empty!
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
  end

  # alias of success
  def processing
    success
  end

  # the card processing failed
  def fail
    flash[:error] = I18n.t(:failed, scope: :payment)
    warn_developers(Wirecard::Base::Error.new, "Something went wrong during the payment.")
    return unless CheckoutCallback.new(current_user, params, :failed).wirecard!.success?
    redirect_to navigation.back(2)
  end

end
