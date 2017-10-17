class Api::Customer::OrdersController < Api::ApplicationController
  attr_reader :order

  authorize_resource class: false
  before_action :set_order

  def destroy
    if order.new?
      order.order_items.delete_all
      order.delete
    else
      OrderCanceller.new(order).all!
      cart_manager.refresh!
    end

    render json: { success: true, msg: I18n.t('edit_order.delete_ok') }
  end

  def update
    order.update(order_params)
    render json: { success: true }
  end

  private

    def set_order
      @order = Order.find(params[:id] || params[:order_id])
    end

    def order_params
      params.require(:order).permit(:special_instructions)
    end
end
