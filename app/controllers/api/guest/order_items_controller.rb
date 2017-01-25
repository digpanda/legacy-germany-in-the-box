class Api::Guest::OrderItemsController < Api::ApplicationController

  attr_reader :order_item, :order

  before_action :set_order_item

  def update

    order = order_item.order
    product = order_item.product
    sku = order_item.sku
    quantity = order_item_params[:quantity].to_i

    # below 0
    if quantity <= 0
      render status: :bad_request,
           json: throw_error(:quantity_too_small).merge(error: I18n.t(:greater_than_zero, :scope => :cart)).to_json
           return
    end

    quantity_difference = quantity - order_item.quantity
    original_quantity = order_item.quantity

    # reach daily limit
    if quantity_difference >= 0 && BuyingBreaker.new(order).with_sku?(sku, quantity_difference)
      # refactor error message (with throw error)
      render :json => {
        :success => false,
        :original_quantity => original_quantity,
        :error => I18n.t(:override_maximal_total, scope: :edit_order, total: Setting.instance.max_total_per_day, currency: Setting.instance.platform_currency.symbol)
       }
      return
    end

    # if we have enough quantity in stock
    if !sku.unlimited && (sku.quantity < quantity)
      # refactor error message (with throw error)
      render :json => {
        :success => false,
        :original_quantity => original_quantity,
        :error => I18n.t(:not_all_available, scope: :checkout, :product_name => product.name, :option_names => sku.option_names.join(', '))
      }
      return
    end

    order_item.quantity = quantity

    # we finally save the order item
    # it passed all the major "validations" (should be moved to models-validators i guess)
    unless order_item.save
      render :json => {
        :success => false,
        :original_quantity => original_quantity,
        :error => order_item.errors.full_messages.join(", ")
      }
      return
    end

    @order = cart_manager.order(shop: product.shop)

    unless order # because there's an API call (could be improved)
      flash[:error] = I18n.t(:borderguru_unreachable_at_quoting, scope: :checkout)
      redirect_to root_path
      return
    end

    if order.coupon
      CouponHandler.new(order.coupon, order).reset
    end

  end

  private

  def order_item_params
    params.permit(:quantity)
  end

  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

end
