class Api::Customer::OrdersController < Api::ApplicationController
  attr_accessor :order

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

    render json: { success: true, msg: I18n.t(:delete_ok, scope: :edit_order) }
  end

  private

    def set_order
      @order = Order.find(params[:id] || params[:order_id])
    end
end
