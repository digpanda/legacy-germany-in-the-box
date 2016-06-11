class Api::Guest::OrderItemsController < Guest::OrderItemsController

  load_and_authorize_resource
  
  # +/- items of the same product
  def set_quantity
    # You can use @order_item here
    # The json-view is in views/api/order_item/set_quantity.json.jbuilder

    p = @order_item.product
    s = p.skus.find(@order_item.sku_id)
    q = params[:quantity].to_i

    new_total = s.price * q * Settings.first.exchange_rate_to_yuan

    if reach_todays_limit?(@order_item.order, new_total)
      render :json => { :msg => I18n.t(:override_maximal_total, scope: :edit_order, total: Settings.instance.max_total_per_day, currency: Settings.instance.platform_currency.symbol) }, :status => :unprocessable_entity
      return
    end

    if s.unlimited or s.quantity >= q
      @order_item.quantity = q
    end

    if @order_item.save
      render :json => { :amount => total_number_of_products }, :status => :ok
    else
      render :json => { :msg => @order_item.errors.full_messages.first }, :status => :unprocessable_entity
    end
  end

end