require 'border_guru'
require 'will_paginate/array'

class OrdersController < ApplicationController

  load_and_authorize_resource

  decorates_assigned :order, :orders

  before_action :authenticate_user_with_force!, :except => [:add_product]
  before_action :set_order, :only => [:show, :destroy, :continue, :download_label]

  layout :custom_sublayout, only: [:show_orders]

  def download_label
    response = BorderGuru.get_label(
        border_guru_shipment_id: @order.border_guru_shipment_id
    )

    SlackDispatcher.new.message("RAW RESPONSE LABEL : #{response.body}")

    send_data response.bindata, filename: "#{@order.border_guru_shipment_id}.pdf", type: :pdf

  # to refactor (obviously)
  rescue BorderGuru::Error, SocketError => exception
    Rails.logger.info "Error Download Label Order \##{@order.id} : #{exception.message}"
    throw_app_error(:resource_not_found, {error: "Your label is not ready yet. Please try again in a few hours."}) # (`#{exception.message}`)
  end

  def show
    @readonly = true
    @currency_code = @order.shop.currency.code

    unless @order.decorate.bought?

      if @order.order_items.count > 0

        begin
          BorderGuru.calculate_quote(
          order: @order,
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

  def set_address
    @address = Address.new
    @user = current_user
  end

  def add_product

    product = Product.find(params[:sku][:product_id]).decorate
    sku = product.sku_from_option_ids(params[:sku][:option_ids].split(','))
    quantity = params[:sku][:quantity].to_i

    order = cart_manager.order(shop: product.shop, call_api: false)
    order.shop = product.shop

    new_increment = sku.price * quantity * Settings.first.exchange_rate_to_yuan
    if reach_todays_limit?(order, new_increment, quantity)
      flash[:error] = I18n.t(:override_maximal_total, scope: :edit_order, total: Settings.instance.max_total_per_day, currency: Settings.instance.platform_currency.symbol)
      redirect_to(:back)
      return
    end

    existing_order_item = order.order_items.to_a.detect { |i| i.sku_id == sku.id.to_s}

    if sku.unlimited or sku.quantity >= quantity
      if existing_order_item.present?
        existing_order_item.quantity += quantity
        existing_order_item.save!
      else
        current_order_item = order.order_items.build
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

      if order.save
        cart_manager.store(order)
        flash[:success] = I18n.t(:add_product_ok, scope: :edit_order)
        redirect_to navigation.back(2, shop_path(product.shop_id))
        return
      end

    end

    flash[:error] = I18n.t(:add_product_ko, scope: :edit_order)
    redirect_to request.referrer and return

  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

end
