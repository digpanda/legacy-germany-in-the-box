class Customer::CheckoutController < ApplicationController

  ACCEPTABLE_PAYMENT_METHOD = [:upop, :creditcard]

  attr_reader :shop, :order

  authorize_resource :class => false
  before_action :set_shop, :only => [:create]

  protect_from_forgery :except => [:success, :fail, :cancel, :processing]

  def create

    @order = cart_manager.order(shop: shop)

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
    return unless current_user.valid_for_checkout?
    return if today_limit?

    all_products_available = true
    products_total_price = 0
    product_name = nil
    sku = nil

    order.order_items.each do |order_item|
      product = order_item.product
      sku = order_item.sku

      if sku.unlimited or sku.quantity >= order_item.quantity
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
      flash[:error] = I18n.t(:not_all_min_total_reached, scope: :checkout, :shop_name => shop.name, :total_price => total_price, :currency => Settings.instance.platform_currency.symbol, :min_total => min_total)
      redirect_to navigation.back(1)
      return
    end

    status = update_for_checkout(order, order.border_guru_quote_id, order.shipping_cost, order.tax_and_duty_cost)

    unless status
      flash[:error] = order.errors.full_messages.join(', ')
      redirect_to navigation.back(1)
      return
    end

    session[:current_checkout_order] = order.id
    redirect_to payment_method_customer_checkout_path

  end

  def payment_method

    if session[:current_checkout_order].nil?
      redirect_to navigation.back(1)
      return
    end

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

    unless BorderGuruApiHandler.new(order).get_shipping!.success?
      SlackDispatcher.new.borderguru_get_shipping_error(order)
    end

    # whatever happens with BorderGuru, if the payment is a success we consider
    # the transaction / order as successful, we will deal with BorderGuru through Slack / Emails
    flash[:success] = I18n.t(:checkout_ok, scope: :checkout)

    EmitNotificationAndDispatchToUser.new.perform({
      :user => shop.shopkeeper,
      :title => "Auftrag #{order.id} am #{order.paid_at}",
      :desc => "Eine neue Bestellung ist da. Zeit für die Vorbereitung!"
      })

    EmitNotificationAndDispatchToUser.new.perform({
      :user => order.user,
      :title => "来因盒通知：付款成功，已通知商家准备发货 （订单号：#{order.id})",
      :desc => "你好，你的订单#{order.id}已成功付款，已通知商家准备发货。若有疑问，欢迎随时联系来因盒客服：customer@germanyinthebox.com。"
      })

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
    flash[:error] = "The payment failed. Please try again."
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

      if order_payment.status == :success
        SlackDispatcher.new.paid_transaction(order_payment)
      else
        SlackDispatcher.new.failed_transaction(order_payment)
      end

      # if it's a success, it paid
      # we freeze the status to unverified for security reason
      # and the payment status freeze on unverified
      order_payment.order.refresh_status_from!(order_payment)
      # END OF COPY

      return true
  end

  def prepare_checkout(order, payment_method)
    @checkout = WirecardCheckout.new(current_user, order, payment_method).checkout!
  rescue Wirecard::Base::Error => exception
    # we should catch the error in the lib or something like this
    # and raise one if the merchant wirecard status isn't active yet
    flash[:error] = "This shop is not ready to accept payments yet (#{exception})"
    redirect_to navigation.back(1)
  end

  def update_for_checkout(order, border_guru_quote_id, shipping_cost, tax_and_duty_cost)
    order.update({
      :status               => :paying,
      :user                 => current_user,
      :border_guru_quote_id => border_guru_quote_id,
      :shipping_cost        => shipping_cost,
      :tax_and_duty_cost    => tax_and_duty_cost
      })
  end

  def update_addresses!

    current_user.addresses.find(params[:delivery_destination_id]).tap do |address|
      order.update(
        shipping_address: address.clone,
        billing_address: address.clone,
      )
    end
  end

  def today_limit?
    if BuyingBreaker.new(order).with_address?(order.shipping_address)
      flash[:error] = I18n.t(:override_maximal_total, scope: :edit_order, total: Settings.instance.max_total_per_day, currency: Settings.instance.platform_currency.symbol)
      redirect_to navigation.back(1)
      return true
    end
  end

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

end
