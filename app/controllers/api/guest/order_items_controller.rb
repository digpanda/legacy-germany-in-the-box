class Api::Guest::OrderItemsController < Guest::OrderItemsController

  load_and_authorize_resource
  
  # +/- items of the same product
  def set_quantity
    # You can use @order_item here
    # The json-view is in views/api/order_item/set_quantity.json.jbuilder

    p = @order_item.product
    s = p.skus.find(@order_item.sku_id)
    q = params[:quantity].to_i
    o = @order_item.order

    new_total = s.price * q * Settings.first.exchange_rate_to_yuan

    if reach_todays_limit?(o, new_total)
      render :json => { :msg => I18n.t(:override_maximal_total, scope: :edit_order, total: Settings.instance.max_total_per_day, currency: Settings.instance.platform_currency.symbol) }, :status => :unprocessable_entity
      return
    end

    if s.unlimited or s.quantity >= q
      @order_item.quantity = q
    else
      render :json => {:msg => I18n.t(:not_all_available, scope: :checkout, :product_name => p.name, :option_names => s.decorate.get_options_txt) }, :status => :unprocessable_entity
    end

    if @order_item.save
      current_cart = current_cart(p.shop.id.to_s).decorate

      render :json => {
                 :amount_in_carts => total_number_of_products,
                 :total_price_with_currency => o.decorate.total_price_with_currency,
                 :duty_cost_with_currency => current_cart.duty_cost_with_currency,
                 :shipping_cost_with_currency => current_cart.shipping_cost_with_currency,
                 :total_with_currency => current_cart.total_with_currency,
             }, :status => :ok
    else
      render :json => { :msg => @order_item.errors.full_messages.first }, :status => :unprocessable_entity
    end
  end

end