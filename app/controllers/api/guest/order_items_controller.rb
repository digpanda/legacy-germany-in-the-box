class Api::Guest::OrderItemsController < Guest::OrderItemsController

  load_and_authorize_resource
  
  # +/- items of the same product
  def set_quantity

    product = @order_item.product
    sku = product.skus.find(@order_item.sku_id)
    quantity = params[:quantity].to_i
    order = @order_item.order

    new_total = sku.price * quantity * Settings.first.exchange_rate_to_yuan

    if @order_item.quantity < quantity && reach_todays_limit?(order, new_total)
      render :json => { :success => false, :error => I18n.t(:override_maximal_total, scope: :edit_order, total: Settings.instance.max_total_per_day, currency: Settings.instance.platform_currency.symbol) }
      return
    end

    if sku.unlimited or sku.quantity >= quantity
      @order_item.quantity = quantity
    else
      render :json => { :success => false, :error => I18n.t(:not_all_available, scope: :checkout, :product_name => product.name, :option_names => sku.decorate.get_options_txt) }
    end

    if @order_item.save
      @current_cart = current_cart(product.shop.id.to_s).decorate
      @total_number_of_products = total_number_of_products
      @order = order
    else
      render :json => { :success => false, :error => @order_item.errors.full_messages.first }
    end
  end

end