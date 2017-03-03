class Customer::Checkout::Callback::WirecardController < ApplicationController

  authorize_resource :class => false
  layout :default_layout
  protect_from_forgery :except => [:success, :fail, :cancel, :processing]

  def success

    return unless callback!

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
    return unless callback!(:failed)
    redirect_to navigation.back(2)
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

end
