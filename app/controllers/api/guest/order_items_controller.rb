class Api::Guest::OrderItemsController < Api::ApplicationController

  attr_reader :order_item
  before_action :set_order_item

  def update

    quantity = order_item_params[:quantity].to_i

    if quantity <= 0
      render status: :bad_request,
           json: throw_error(:quantity_too_small).merge(error: I18n.t(:greater_than_zero, :scope => :cart)).to_json and return
    end

    product = @order_item.product
    sku = product.skus.find(@order_item.sku_id)
    order = @order_item.order

    new_quantity_inc = (quantity - @order_item.quantity)

    new_price_inc = sku.price * new_quantity_inc * Settings.first.exchange_rate_to_yuan

    if new_quantity_inc >= 0 && reach_todays_limit?(order, new_price_inc, new_quantity_inc)
      render :json => { :success => false, :error => I18n.t(:override_maximal_total, scope: :edit_order, total: Settings.instance.max_total_per_day, currency: Settings.instance.platform_currency.symbol) }
      return
    end

    if sku.unlimited or sku.quantity >= quantity
      @order_item.quantity = quantity
    else
      render :json => { :success => false, :error => I18n.t(:not_all_available, scope: :checkout, :product_name => product.name, :option_names => sku.decorate.get_options_txt) }
      return
    end

    if @order_item.save

      cart = current_cart(product.shop.id.to_s)

      if cart.nil?
        flash[:error] = I18n.t(:borderguru_unreachable_at_quoting, scope: :checkout)
        redirect_to root_path and return
      end

      @current_cart = cart
      @total_number_of_products = total_number_of_products
      @order = order
    else
      render :json => { :success => false, :error => @order_item.errors.full_messages.join(", ") }
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
