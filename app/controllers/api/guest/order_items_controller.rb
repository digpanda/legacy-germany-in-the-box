class Api::Guest::OrderItemsController < Api::ApplicationController

  attr_reader :order_item, :order

  before_action :set_order_item, except: :create

  def create
    store_in_cart
  end

  # NOTE : this should be totally refactored. it's fucking shit.
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
    original_total = order_item.total_price_with_taxes.in_euro.to_yuan.display

    # reach daily limit
    if quantity_difference >= 0 && BuyingBreaker.new(order).with_sku?(sku, quantity_difference)
      # refactor error message (with throw error)
      render :json => {
        :success => false,
        :original_quantity => original_quantity,
        :original_total => original_total,
        :error => I18n.t(:override_maximal_total, scope: :edit_order, total: Setting.instance.max_total_per_day, currency: Setting.instance.platform_currency.symbol)
       }
      return
    end

    # if we have enough quantity in stock
    sku_origin = product.sku_from_option_ids(sku.option_ids)

    unless sku_origin&.stock_available_in_order?(quantity_difference, order_item.order)
      render json: throw_error(:unable_to_process)
                       .merge(original_quantity: original_quantity, original_total: original_total,
                              error: I18n.t(:not_all_available, scope: :checkout, product_name: product.name, option_names: sku.display_option_names))
      return
    end

    order_item.quantity = quantity

    # we finally save the order item
    # it passed all the major "validations" (should be moved to models-validators i guess)
    unless order_item.save
      render :json => {
        :success => false,
        :original_quantity => original_quantity,
        :original_total => original_total,
        :error => order_item.errors.full_messages.join(", ")
      }
      return
    end

    @order = cart_manager.order(shop: product.shop, call_api: false)

    unless order # because there's an API call (could be improved)
      flash[:error] = I18n.t(:borderguru_unreachable_at_quoting, scope: :checkout)
      redirect_to root_path
      return
    end

    order.refresh_shipping_cost
    order.save
    order.reload

    if order.coupon
      CouponHandler.new(identity_solver, order.coupon, order).reset
    end

  end

  def destroy
    if order_item.destroy && destroy_empty_order!
      @order = order_item.order

      if @order.persisted?
        CouponHandler.new(identity_solver, order.coupon, order).reset if order.coupon
        render 'api/guest/order_items/update'
      else
        render json: {success: true, order_empty: !@order.persisted?}
      end
    else
      render json: throw_error(:unable_to_process).merge(error: order_item.errors.full_messages.join(', '))
    end
  end

  def destroy_empty_order!
    order = order_item.order

    if order.destroyable?
      order.remove_coupon(identity_solver) if order.coupon
      order.reload
      return order.destroy
    end

    true
  end

  private

  def order_item_params
    params.permit(:quantity)
  end

  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  # TODO : this must be totally refactored
  def store_in_cart

    @product = Product.find(params[:product_id])
    @quantity = params[:quantity].to_i
    @sku = @product.sku_from_option_ids(params[:option_ids].split(','))
    @order = cart_manager.order(shop: @product.shop, call_api: false)

    if @quantity <= 0
      render json: throw_error(:unable_to_process).merge(error: I18n.t(:not_available, scope: :popular_products))
      return
    end

    if BuyingBreaker.new(@order).with_sku?(@sku, @quantity)
      render json: throw_error(:unable_to_process)
                       .merge(error: I18n.t(:override_maximal_total,
                                            scope: :edit_order, total: Setting.instance.max_total_per_day,
                                            currency: Setting.instance.platform_currency.symbol))
      return
    end

    order = OrderMaker.new(@order).add(@sku, @product, @quantity)

    if order.success?
      cart_manager.store(@order)
      render json: {success: true, msg: order.data[:msg]}
    else
      render json: throw_error(:unable_to_process).merge(error: order.error[:error])
    end
  end

end
