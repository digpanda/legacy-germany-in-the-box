require 'border_guru'
require 'will_paginate/array'

class OrdersController < ApplicationController

  before_action :authenticate_user!, :except => [:manage_cart, :add_product]

  before_action :set_order, only: [:show, :destroy, :continue, :download_label]

  protect_from_forgery :except => [:checkout_success, :checkout_fail]

  load_and_authorize_resource

  layout :custom_sublayout, only: [:show_orders]

  def download_label
    response = BorderGuru.get_label(
        border_guru_shipment_id: @order.border_guru_shipment_id
    ) 
    send_data response.bindata, filename: "#{@order.border_guru_shipment_id}.pdf", type: :pdf
  end

  def show_orders
    if current_user.is_customer?
      @orders = current_user.orders.nonempty.order_by(:c_at => 'desc').paginate(:page => (params[:page] ? params[:page].to_i : 1), :per_page => 10);
    elsif current_user.is_shopkeeper?
      @orders = current_user.shop.orders.paid.order_by(:c_at => 'desc').paginate(:page => (params[:page] ? params[:page].to_i : 1), :per_page => 10);
    elsif current_user.is_admin?
      @orders = Order.order_by(:c_at => 'desc').paginate(:page => (params[:page] ? params[:page].to_i : 1), :per_page => 10);
    end

    render "orders/#{current_user.role.to_s}/show_orders"
  end

  def show
    @readonly = true
    @currency_code = @order.order_items.first.sku.product.shop.currency.code
  end

  def manage_cart
    @readonly = false
    @shops = Shop.only(:name).where(:id.in => current_orders.keys).map { |s| [s.id.to_s, {:name => s.name}]}.to_h
    @carts = current_carts
  end

  def set_address
    @address = Address.new
    @user = current_user
  end

  def add_product

    product = Product.find(params[:sku][:product_id])
    sku = product.get_sku(params[:sku][:option_ids].split(','))
    quantity = params[:sku][:quantity].to_i

    co = current_order(product.shop_id.to_s)
    co.shop = product.shop

    new_total = sku.price * quantity * Settings.first.exchange_rate_to_yuan

    if reach_todays_limit?(co, new_total)
      flash[:error] = I18n.t(:override_maximal_total, scope: :edit_order, total: Settings.instance.max_total_per_day, currency: Settings.instance.platform_currency.symbol)
      redirect_to(:back) and return
    end

    existing_order_item = co.order_items.to_a.detect { |i| i.sku_id == sku.id.to_s}

    if sku.unlimited or sku.quantity >= quantity
      if existing_order_item.present?
        existing_order_item.quantity += quantity
        existing_order_item.save!
      else
        current_order_item = co.order_items.build
        current_order_item.price = sku.price
        current_order_item.quantity = quantity
        current_order_item.weight = sku.weight
        current_order_item.product = product
        current_order_item.product_name = product.name
        current_order_item.sku_id = sku.id.to_s
        current_order_item.option_ids = sku.option_ids
        current_order_item.option_names = sku.get_options
        current_order_item.save!
      end

      if co.save
        flash[:success] = I18n.t(:add_product_ok, scope: :edit_order)
        redirect_to navigation_history(2, shop_path(product.shop_id)) and return
      end

    end

    flash[:error] = I18n.t(:add_product_ko, scope: :edit_order)
    redirect_to request.referrer and return

  end

  def checkout
    shop_id = params[:shop_id]

    order = current_order(shop_id)

    if reach_todays_limit?(order, 0)
      flash[:error] = I18n.t(:override_maximal_total, scope: :edit_order, total: Settings.instance.max_total_per_day, currency: Settings.instance.platform_currency.symbol)
      redirect_to request.referrer
      return
    end

    cart = current_cart(shop_id)

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

    status = order.update_for_checkout!(current_user, params[:delivery_destination_id], cart.border_guru_quote_id, cart.shipping_cost, cart.tax_and_duty_cost)

    if status
      @wirecard = PrepareOrderForWirecardCheckout.perform({

        :user        => current_user,
        :order       => order,
        :merchant_id => Rails.env.production? ? cart.submerchant_id : 'dfc3a296-3faf-4a1d-a075-f72f1b67dd2a', # TO CHANGE DYNAMICALLY
        :secret_key  => "6cbfa34e-91a7-421a-8dde-069fc0f5e0b8", # TO CHANGE DYNAMICALLY
        :amount      => cart.decorate.total_in_yuan,
        :currency    => "CNY"

      })
    end
  end

  def checkout_success
    checkout_callback

    op = OrderPayment.where(:request_id => params[:request_id]).first
    order = op.order
    shop = order.order_items.first.sku.product.shop

    begin
      shipping = BorderGuru.get_shipping(
          order: order,
          shop: shop,
          country_of_destination: ISO3166::Country.new('CN'),
          currency: 'EUR'
      )
    rescue
      flash[:error] = I18n.t(:borderguru_unreachable_at_shipping, scope: :checkout)
      redirect_to root_path
      return
    end

    if shipping.success? && order.save
      order.order_items.each do |oi|
        oi.sku.quantity -= oi.quantity unless oi.sku.unlimited
        oi.price = oi.sku.price
        oi.save!

        #if oi.save
        #  session[:order_ids]&.delete(shop.id.to_s)
        #end

      end

      remove_shop_id_from_session(shop.id.to_s)

      flash[:success] = I18n.t(:checkout_ok, scope: :checkout)
      redirect_to show_orders_users_path(:user_info_edit_part => :edit_order)

    else

      flash[:error] = current_order.errors.full_messages.first
      redirect_to request.referrer

    end
  end

  def checkout_fail
    checkout_callback
  end

  def checkout_callback

    customer_email = params["email"]

    # corrupted transaction detected : not the same email -> should be improved / put somewhere else
    if current_user.email != customer_email
        flash[:error] = "An account conflict occurred. Please contact our support."
        redirect_to root_url and return
    end

    UpdateOrderAndPaymentFromWirecardTransaction.perform(params.symbolize_keys)

  end

  def destroy
    shop_id = @order.order_items.first.sku.product.shop.id.to_s
    session[:order_ids]&.delete(shop_id)

    if @order && @order.status != :success && @order.order_items.delete_all && @order.delete

      flash[:success] = I18n.t(:delete_ok, scope: :edit_order)
      redirect_to request.referrer

    else

      flash[:error] = I18n.t(:delete_ko, scope: :edit_order)
      redirect_to request.referrer
      
    end
  end

  def continue
    shop_id = @order.order_items.first.product.shop.id.to_s

    unless (co = current_order(shop_id))
      session[:order_ids][shop_id] = @order.id.to_s
    else
      if @order != co
        @order.order_items.each do |ooi|
          coi = co.order_items.detect { |coi| ooi.sku_id == coi.sku_id }

          if coi
            coi.quantity += ooi.quantity
            coi.save
          else
            sku = ooi.product.get_sku(ooi.option_ids)
            noi = co.order_items.build
            noi.price = sku.price
            noi.quantity = ooi.quantity
            noi.weight = sku.weight
            noi.product = sku.product
            noi.product_name = sku.product.name
            noi.sku_id = sku.id.to_s
            noi.option_ids = sku.option_ids
            noi.option_names = sku.get_options
            noi.save
          end

          ooi.delete
        end

        @order.order_items.delete_all
        @order.delete

        flash[:info] = I18n.t(:continue_message, scope: :edit_order)
      end
    end

    redirect_to manage_cart_orders_path
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

end
