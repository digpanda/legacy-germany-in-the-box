class Admin::OrderItemsController < ApplicationController

  CSV_ENCODE = "UTF-8"

  attr_accessor :order_item, :order_items

  authorize_resource :class => false
  before_action :set_order_item

  def update
    if order_item.update(order_item_params)
      flash[:success] = "The order item was updated."
    else
      flash[:error] = "The order item was not updated (#{order_item.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  private

  def order_item_params
    params.require(:order_item).permit!
  end

  def set_order_item
    @order_item = OrderItem.find(params[:id] || params[:order_item_id])
  end

end
