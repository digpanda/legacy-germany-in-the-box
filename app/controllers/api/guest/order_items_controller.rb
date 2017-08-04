class Api::Guest::OrderItemsController < Api::ApplicationController
  attr_reader :order, :order_item, :product, :sku, :quantity

  before_action :set_product_and_sku, :set_order, only: :create
  before_action :set_order_item, except: :create
  before_action :set_quantity, only: [:create, :update]

  # we add the sku through the order maker and check success
  # if it's a success, we store the order into the cart
  def create
    add_sku = order_maker.sku(sku).refresh!(quantity)
    if add_sku.success?
      cart_manager.store(order)
      render json: { success: true, message: I18n.t(:add_product_ok, scope: :edit_order) }
    else
      render json: throw_error(:unable_to_process).merge(error: add_sku.error[:error])
    end
  end

  def update
    @order = order_item.order
    @sku = order_item.sku

    quantity_difference = quantity - order_item.quantity
    quantity_difference = 0 if quantity == 0 # this will be stopped later on within the process

    original_quantity = order_item.quantity
    original_total = order_item.total_price_with_taxes.in_euro.to_yuan(exchange_rate: order_item.order.exchange_rate).display

    # NOTE : we base our order maker mechanism on the sku origin
    # and not the order item sku, be aware of that.
    refresh = order_maker.sku(order_item.sku_origin).refresh!(quantity_difference)
    unless refresh.success?
      render json: throw_error(:unable_to_process)
                   .merge(error: refresh.error[:error],
                          original_quantity: original_quantity,
                          original_total: original_total)
      return
    end

    # mongoid is a joke
    # - Laurent
    order.reload
  end

  def destroy
    @order = order_item.order
    @sku = order_item.sku

    remove = order_maker.sku(order_item.sku_origin).remove!

    unless remove.success?
      render json: throw_error(:unable_to_process).merge(error: remove.error[:error])
    end
  end

  private

    def order_maker
      @order_maker ||= OrderMaker.new(identity_solver, order)
    end

    def set_product_and_sku
      @product = Product.find(params[:product_id])
      @sku = product.skus.where(id: params[:sku_id]).first
    end

    def set_order
      @order = cart_manager.order(shop: product.shop)
    end

    def set_order_item
      @order_item = OrderItem.find(params[:id])
    end

    def set_quantity
      @quantity = params[:quantity].to_i
    end
end
