class Customer::CheckoutController < ApplicationController

  ACCEPTABLE_PAYMENT_METHOD = [:upop, :creditcard]

  attr_reader :shop, :order

  authorize_resource :class => false
  before_action :set_shop, :only => [:create]
  before_action :set_order, :except => [:payment_method]
  before_filter :ensure_session_order, :only => [:payment_method]

  before_action :breadcrumb_cart, :breadcrumb_checkout_address, :breadcrumb_payment_method, only: :payment_method

  protect_from_forgery :except => [:success, :fail, :cancel, :processing]

  before_action :freeze_header

  def create

    @order = cart_manager.order(shop: shop, call_api: false)

    # we check the address has been selected
    unless params[:delivery_destination_id]
      flash[:error] = "Please choose a delivery address."
      redirect_to navigation.back(1)
      return
    end

    # we update the delivery address before everything
    # this will be used to check the limit reach
    update_addresses!

    # TODO : this should be in a before action or something (or at least something more logical and also grouped with the delivery destination id check)
     unless current_user.valid_for_checkout?
       redirect_to navigation.back(1)
       return
     end
    return if today_limit?

    all_products_available = true
    products_total_price = 0
    product_name = nil
    sku = nil

    order.order_items.each do |order_item|
      product = order_item.product
      sku = order_item.sku
      sku_origin = order_item.sku_origin

      if sku_origin.enough_stock?(order_item.quantity)
        all_products_available = true
        products_total_price += sku.price * order_item.quantity
      else
        all_products_available = false
        product_name = product.name
        break
      end
    end

    if !all_products_available
      flash[:error] = I18n.t(:not_all_available, scope: :checkout, :product_name => product_name, :option_names => sku.option_names.join(', '))
      redirect_to navigation.back(1)
      return
    end

    if products_total_price < shop.min_total
      total_price = Currency.new(products_total_price).to_yuan.display
      min_total = Currency.new(shop.min_total).to_yuan.display
      flash[:error] = I18n.t(:not_all_min_total_reached, scope: :checkout, :shop_name => shop.name, :total_price => total_price, :currency => Setting.instance.platform_currency.symbol, :min_total => min_total)
      redirect_to navigation.back(1)
      return
    end

    status = update_for_checkout(order, order.border_guru_quote_id)

    unless status
      flash[:error] = order.errors.full_messages.join(', ')
      redirect_to navigation.back(1)
      return
    end

    session[:current_checkout_order] = order.id
    redirect_to payment_method_customer_checkout_path

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

    payment_method = params[:payment_method].to_sym
    order = Order.find(params[:order_id])

    unless acceptable_payment_method?(payment_method)
      flash[:error] = "Invalid payment method."
      redirect_to navigation.back(1)
      return
    end

    prepare_checkout(order, payment_method)

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

    BorderGuruApiHandler.new(order).calculate_and_get_shipping

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
    EmitNotificationAndDispatchToUser.new.perform_if_not_sent({
                                                                  order: order,
                                                                  user: order.shop.shopkeeper,
                                                                  title: "Auftrag #{order.id} am #{order.paid_at}",
                                                                  desc: 'Haben Sie die Bestellung schon vorbereiten? Senden Sie die bitte!'
                                                              })
    EmitNotificationAndDispatchToUser.new.perform_if_not_selected_sent({
                                                                           order: order,
                                                                           user: order.shop.shopkeeper,
                                                                           title: "Auftrag #{order.id} am #{order.paid_at}",
                                                                           desc: "Haben Sie die Bestellung schon gesendet? Klicken Sie bitte 'Das Paket wurde versandt'"
                                                                       })
  end

  def prepare_checkout(order, payment_method)
    @checkout = WirecardCheckout.new(root_url, current_user, order, payment_method).checkout!
  rescue Wirecard::Base::Error => exception
    # we should catch the error in the lib or something like this
    # and raise one if the merchant wirecard status isn't active yet
    flash[:error] = "This shop is not ready to accept payments yet (#{exception})"
    redirect_to navigation.back(1)
  end

  def update_for_checkout(order, border_guru_quote_id)
    # we bypass the validation of the locked for this one because there's no reason to make it fail here
    # order.bypass_locked!
    # now we update the order itself
    # NOTE : for some reason it cannot update without bypassing the locked ; we should investigate
    order.update({
      :status               => :paying,
      :user                 => current_user,
      :border_guru_quote_id => border_guru_quote_id,
      })
  end

  def update_addresses!
    current_user.addresses.find(params[:delivery_destination_id]).tap do |address|
      order.update(shipping_address: nil, billing_address: nil)
      order.update(shipping_address: address.clone, billing_address: address.clone)
    end
  end

  def today_limit?
    if BuyingBreaker.new(order).with_address?(order.shipping_address)
      flash[:error] = I18n.t(:override_maximal_total, scope: :edit_order, total: Setting.instance.max_total_per_day, currency: Setting.instance.platform_currency.symbol)
      redirect_to navigation.back(1)
      return true
    end
  end

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def set_order
    @order = Order.find(session[:current_checkout_order])
    @order = cart_manager.order(shop: @order.shop, call_api: false)
  end

  def ensure_session_order
    if session[:current_checkout_order].nil?
      redirect_to navigation.back(1)
      return false
    end
    true
  end

end
