class Customer::CheckoutController < ApplicationController

  before_action :authenticate_user!
  before_action :set_shop, :only => [:create]

  protect_from_forgery :except => [:success, :fail, :cancel, :processing]
  attr_reader :shop

  def create

    order = current_order(shop.id.to_s)
    cart = current_cart(shop.id.to_s)

    return if wrong_email_update?
    return if today_limit?(order)
    return if invalid_cart?(cart)

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
      msg = I18n.t(:not_all_available, scope: :checkout, :product_name => product_name, :option_names => sku.decorate.get_options_txt)
      flash[:error] = msg
      redirect_to request.referrer
      return
    end

    if products_total_price < shop.min_total
      total_price = Currency.new(products_total_price).to_yuan.display
      min_total = Currency.new(shop.min_total).to_yuan.display
      flash[:error] = I18n.t(:not_all_min_total_reached, scope: :checkout, :shop_name => shop.name, :total_price => total_price, :currency => Settings.instance.platform_currency.symbol, :min_total => min_total)
      redirect_to navigation.back(1)
      return
    end

    status = update_for_checkout(current_user, order, params[:delivery_destination_id], cart.border_guru_quote_id, cart.shipping_cost, cart.tax_and_duty_cost)
    prepare_checkout(status, order)

  end

  def success

    return unless callback!

    order_payment = OrderPayment.where(:request_id => params[:request_id]).first
    order = order_payment.order
    shop = order.shop

    order.order_items.each do |order_item|
      sku = order_item.sku
      sku.quantity -= order_item.quantity unless sku.unlimited
      sku.save!
    end

    reset_shop_id_from_session(shop.id.to_s)

    if BorderGuruApiHandler.new(order).get_shipping!.success?
      flash[:success] = I18n.t(:checkout_ok, scope: :checkout)
    else
      flash[:error] = I18n.t(:borderguru_shipping_failed, scope: :checkout)
    end

    EmitNotificationAndDispatchToUser.new.perform({
      :user => shop.shopkeeper,
      :title => "Auftrag #{order.id} am #{order.paid_at}",
      :desc => "Eine neue Bestellung ist da. Zeit für die Vorbereitung!"
      })

    EmitNotificationAndDispatchToUser.new.perform({
      :user => order.user,
      :title => "来因盒通知：付款成功，已通知商家准备发货 （订单号：#{order.id})",
      :desc => ""
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
    ExceptionNotifier.notify_exception(Wirecard::Base::Error.new, :env => request.env, :data => {:message => "Something went wrong during the payment."})
    return unless callback!(:failed)
    redirect_to navigation.back(2)
  end

  private

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

  def prepare_checkout(status, order)
    if status
      begin
        @checkout = WirecardCheckout.new(current_user, order).checkout!
      rescue Wirecard::Base::Error => exception
        # we should catch the error in the lib or something like this
        # and raise one if the merchant wirecard status isn't active yet
        flash[:error] = "This shop is not ready to accept payments yet (#{exception})"
        redirect_to navigation.back(1)
        return
      end
    else
      flash[:error] = order.errors.full_messages.join(', ')
      redirect_to navigation.back(1)
      return
    end
  end

  def update_for_checkout(user, order, delivery_destination_id, border_guru_quote_id, shipping_cost, tax_and_duty_cost)
    user.addresses.find(delivery_destination_id).tap do |address|
      order.update({
        :status               => :paying,
        :user                 => user,
        :shipping_address     => address,
        :billing_address      => address,
        :border_guru_quote_id => border_guru_quote_id,
        :shipping_cost        => shipping_cost,
        :tax_and_duty_cost    => tax_and_duty_cost
        })
    end
  end

  def wrong_email_update?
    if params[:valid_email]
      if User.where(email: params[:valid_email]).first
        flash[:error] = "This email is currently used by someone else."
        redirect_to navigation.back(1)
        return true
      end
      current_user.email = params[:valid_email]
      current_user.save

      return false
    end
  end

  def today_limit?(order)
    if reach_todays_limit?(order, 0, 0)
      flash[:error] = I18n.t(:override_maximal_total, scope: :edit_order, total: Settings.instance.max_total_per_day, currency: Settings.instance.platform_currency.symbol)
      redirect_to navigation.back(1)
      return true
    end
  end

  def invalid_cart?(cart)
    if cart.nil?
      flash[:error] = I18n.t(:borderguru_unreachable_at_quoting, scope: :checkout)
      redirect_to root_path
      return true
    end
  end

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

end
