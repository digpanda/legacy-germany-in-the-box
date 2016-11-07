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

    send_data response.bindata, filename: "#{@order.border_guru_shipment_id}.pdf", type: :pdf

  # to refactor (obviously)
  rescue BorderGuru::Error, SocketError => exception
    Rails.logger.info "Error Download Label Order \##{@order.id} : #{exception.message}"
    throw_app_error(:resource_not_found, {error: "Your label is not ready yet. Please try again in a few hours."})
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

    if BuyingBreaker.new(order).with_sku?(sku, quantity)
      flash[:error] = I18n.t(:override_maximal_total, scope: :edit_order, total: Settings.instance.max_total_per_day, currency: Settings.instance.platform_currency.symbol)
      redirect_to(:back)
      return
    end

    existing_order_item = order.order_items.to_a.detect { |i| i.sku_id == sku.id.to_s}

    if sku.unlimited || (sku.quantity >= quantity)
      if existing_order_item.present?
        existing_order_item.quantity += quantity
        existing_order_item.save!
      else
        OrderMaker.new(order).add(sku, quantity)
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
