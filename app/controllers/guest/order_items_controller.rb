class Guest::OrderItemsController < ApplicationController

  before_action :set_order_item, :set_order

  attr_reader :order_item, :order

  def destroy
    if order_item.delete && destroy_empty_order!
      flash[:success] = I18n.t(:item_removed, scope: :notice)
    else
      flash[:error] = order_item.errors.full_messages.join(', ')
    end
    redirect_to(:back) and return
  end

  private

  def destroy_empty_order!
    if order.destroyable?
      order.reload # because we just deleted the order item
      return order.delete
    end
    true
  end

  def set_order_item
    @order_item = OrderItem::find(params[:id]) unless params[:id].nil?
  end

  def set_order
    @order = order_item.order if order_item
  end

end
