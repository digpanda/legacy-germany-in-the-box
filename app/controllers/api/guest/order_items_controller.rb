class Api::Guest::OrderItemsController < Api::ApplicationController

  attr_reader :order_item
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

    # reach daily limit
    if quantity_difference >= 0 && BuyingBreaker.new(order).with_sku?(sku, quantity_difference)
      # refactor error message (with throw error)
      render :json => {
        :success => false,
        :original_quantity => @order_item.quantity,
        :error => I18n.t(:override_maximal_total, scope: :edit_order, total: Settings.instance.max_total_per_day, currency: Settings.instance.platform_currency.symbol)
       }
      return
    end

    # if we have enough quantity in stock
    if !sku.unlimited && (sku.quantity < quantity)
      # refactor error message (with throw error)
      render :json => {
        :success => false,
        :original_quantity => @order_item.quantity,
        :error => I18n.t(:not_all_available, scope: :checkout, :product_name => product.name, :option_names => sku.decorate.get_options_txt)
      }
      return
    end

    order_item.quantity = quantity

    # we save it now
    if order_item.save

      @order = cart_manager.order(shop: product.shop)

      unless @order
        flash[:error] = I18n.t(:borderguru_unreachable_at_quoting, scope: :checkout)
        redirect_to root_path
        return
      end

      @total_number_of_products = total_number_of_products

    else
      render :json => { :success => false, :original_quantity => @order_item.quantity, :error => order_item.errors.full_messages.join(", ") }
    end

    # we don't forget to refresh the discount (coupon system)
    unless order.coupon.nil?
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
