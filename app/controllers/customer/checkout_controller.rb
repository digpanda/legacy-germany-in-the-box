class Customer::CheckoutController < ApplicationController

  before_action :authenticate_user!

  protect_from_forgery :except => [:success, :fail, :cancel, :processing]

  def create

    # Small hack to be improved - Laurent
    if params[:valid_email]
      if User.where(email: params[:valid_email]).first
        flash[:error] = "This email is currently used by someone else."
        redirect_to navigation.back(1)
        return
      end
      current_user.email = params[:valid_email]
      current_user.save
    end

    shop_id = params[:shop_id]
    order = current_order(shop_id)

    if reach_todays_limit?(order, 0, 0)
      flash[:error] = I18n.t(:override_maximal_total, scope: :edit_order, total: Settings.instance.max_total_per_day, currency: Settings.instance.platform_currency.symbol)
      redirect_to request.referrer
      return
    end

    cart = current_cart(shop_id)

    if cart.nil?
      flash[:error] = I18n.t(:borderguru_unreachable_at_quoting, scope: :checkout)
      redirect_to root_path and return
    end

    all_products_available = true;
    products_total_price = 0
    product_name = nil
    sku = nil

    order.order_items.each do |oi|
      product = oi.product
      sku = oi.sku

      if sku.unlimited or sku.quantity >= oi.quantity
        all_products_available = true
        products_total_price += sku.price * oi.quantity
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

    @shop = Shop.only(:currency, :min_total, :name).find(shop_id)

    if products_total_price < @shop.min_total
      tp = "%.2f" % (products_total_price * Settings.instance.exchange_rate_to_yuan)
      mt = "%.2f" % (@shop.min_total * Settings.instance.exchange_rate_to_yuan)

      msg = I18n.t(:not_all_min_total_reached, scope: :checkout, :shop_name => @shop.name, :total_price => tp, :currency => Settings.instance.platform_currency.symbol, :min_total => mt)

      flash[:error] = msg
      redirect_to request.referrer
      return

    end

    # should be put into a service or something instead of being here - Laurent
    status = update_for_checkout(current_user, order, params[:delivery_destination_id], cart.border_guru_quote_id, cart.shipping_cost, cart.tax_and_duty_cost)

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

  def success
    callback!

    order_payment = OrderPayment.where(:request_id => params[:request_id]).first
    order = order_payment.order
    shop = order.shop

    order.order_items.each do |oi|
      sku = oi.sku
      sku.quantity -= oi.quantity unless sku.unlimited
      sku.save!
    end

    reset_shop_id_from_session(shop.id.to_s)

    EmitNotificationAndDispatchToUser.new.perform({
      :user => shop.shopkeeper,
      :title => 'Sie haben eine neue Bestellung aus dem Land der Mitte bekommen!',
      :desc => "Eine neue Bestellung ist da. Zeit für die Vorbereitung!"
      })

      if BorderGuruApiHandler.new(order).get_shipping!.success?

        flash[:success] = I18n.t(:checkout_ok, scope: :checkout)
        redirect_to customer_orders_path(:user_info_edit_part => :edit_order)
        return

      else

        flash[:error] = I18n.t(:borderguru_shipping_failed, scope: :checkout)
        redirect_to customer_orders_path(:user_info_edit_part => :edit_order)
        return

      end

    end

    # make the user return to the previous page
    def cancel
      redirect_to navigation.back(2)
      return
    end

    def processing
      success
    end

    def checkout_fail # TODO: manage that better, right now it doesn't work
      flash[:error] = "The payment failed. Please try again."
      ExceptionNotifier.notify_exception(Wirecard::Base::Error.new, :env => request.env, :data => {:message => "Something went wrong during the payment."})
      callback!(:failed)
      redirect_to navigation.back(2)
    end

    private

    def callback!(forced_status=nil)

      customer_email = params["email"]

      # corrupted transaction detected : not the same email -> should be improved / put somewhere else
      if current_user.email != customer_email
        flash[:error] = I18n.t(:account_conflict, scope: :notice)
        redirect_to root_url
        return
      end

      # TODO : TO IMPROVE
      merchant_id = params["merchant_account_id"]
      request_id = params["request_id"]
      order_payment = OrderPayment.where({merchant_id: merchant_id, request_id: request_id}).first
      WirecardPaymentChecker.new(params.symbolize_keys.merge({:order_payment => order_payment})).update_order_payment!
      order_payment.status = forced_status unless forced_status.nil? # TODO : improve this
      order_payment.save

      # TODO: TO IMPROVE TOO
      if order_payment.status == :success
        SlackDispatcher.new.paid_transaction(order_payment)
      else
        SlackDispatcher.new.failed_transaction(order_payment)
      end

      # if it's a success, it paid
      # we freeze the status to unverified for security reason
      # and the payment status freeze on unverified
      order_payment.order.refresh_status_from!(order_payment)

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

end
