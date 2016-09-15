require 'border_guru'
require 'will_paginate/array'

class OrdersController < ApplicationController

  load_and_authorize_resource

  decorates_assigned :order, :orders

  before_action :authenticate_user_with_force!, :except => [:manage_cart, :add_product]
  before_action :set_order, :only => [:show, :destroy, :continue, :download_label]

  layout :custom_sublayout, only: [:show_orders]

  def download_label
    response = BorderGuru.get_label(
        border_guru_shipment_id: @order.border_guru_shipment_id
    )
    send_data response.bindata, filename: "#{@order.border_guru_shipment_id}.pdf", type: :pdf

  # to refactor (obviously)
  rescue BorderGuru::Error, SocketError => exception
    Rails.logger.info "Error Download Label Order \##{@order.id} : #{exception.message}"
    throw_app_error(:resource_not_found, {error: "Your label is not ready yet. Please try again in a few hours."}) # (`#{exception.message}`)
  end

  def show
    @readonly = true
    @currency_code = @order.shop.currency.code

    if @order.decorate.is_bought?
      @cart_or_order = @order
    else
      @cart_or_order = Cart.new

      @order.order_items.each do |i|
        @cart_or_order.decorate.add(i.sku, i.quantity)
      end

      # THIS SHOULD BE REALLY FUCKING REFACTORED
      # THIS IS DISGUSTING.
      # - Laurent 01/09/2016
      if @order.order_items.count > 0

        begin
          BorderGuru.calculate_quote(
              cart: @cart_or_order,
              shop: @order.shop,
              country_of_destination: ISO3166::Country.new('CN'),
              currency: 'EUR'
          )
        rescue Net::ReadTimeout => e
          logger.fatal "Failed to connect to Borderguru: #{e}"
          return nil
        end

      end
    end
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

    product = Product.find(params[:sku][:product_id]).decorate
    sku = product.sku_from_option_ids(params[:sku][:option_ids].split(','))
    quantity = params[:sku][:quantity].to_i

    co = current_order(product.shop_id.to_s)
    co.shop = product.shop

    new_increment = sku.price * quantity * Settings.first.exchange_rate_to_yuan

    if reach_todays_limit?(co, new_increment, quantity)
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
        redirect_to navigation.back(2, shop_path(product.shop_id))
        return
      end

    end

    flash[:error] = I18n.t(:add_product_ko, scope: :edit_order)
    redirect_to request.referrer and return

  end

  def destroy

    shop_id = @order.shop.id.to_s
    session[:order_ids]&.delete(shop_id)
    @order.status = :cancelled
    @order.save

    # NOTE : for legacy purpose this method is still here.
    # but the cancel by shopkeeper are used on another side from now on
    # it's only for admins until we refactor the whole controller
    if current_user&.decorate.admin?
      @order && @order.status != :success
      @order.order_items.delete_all
      @order.delete
    end

    flash[:success] = I18n.t(:delete_ok, scope: :edit_order)
    redirect_to request.referrer

  end

  def continue
    shop_id = @order.shop_id.to_s

    unless (co = current_order(shop_id))
      session[:order_ids][shop_id] = @order.id.to_s
    else
      if @order != co

        @order.order_items.each do |ooi|
          sku = ooi.sku

          ooi.price = sku.price
          ooi.weight = sku.weight
          ooi.product_name = sku.product.name
          ooi.option_ids = sku.option_ids
          ooi.option_names = sku.get_options
        end

        if @order.order_items.each(&:save)
          set_order_id_in_session(shop_id, @order.id.to_s)
          flash[:success] = I18n.t(:continue_ok, scope: :edit_order)
        else
          flash[:error] = @orde.errors.full_messages.first
        end

      end
    end

    redirect_to manage_cart_orders_path
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

end
