class Admin::OrderItemsController < ApplicationController

  CSV_ENCODE = "UTF-8"

  attr_accessor :order_item, :order_items, :order

  authorize_resource :class => false
  before_action :set_order_item, :set_order

  def update
    if order_item.update(order_item_params)
      flash[:success] = "The order item was updated."
    else
      flash[:error] = "The order item was not updated (#{order_item.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  # we refresh the referrer rate and the provision linked to it
  def refresh_referrer_rate
    order_item.refresh_referrer_rate!
    order_item.bypass_locked!
    order_item.save
    order.refresh_referrer_provision!
    order.bypass_locked!
    order.save
    flash[:success] = "The referrer rate for this order item was refreshed."
    redirect_to navigation.back(1)
  end

  private

  def order_item_params
    params.require(:order_item).permit!
  end

  def set_order_item
    @order_item = OrderItem.find(params[:id] || params[:order_item_id])
  end

  def set_order
    @order = order_item.order
  end

end
