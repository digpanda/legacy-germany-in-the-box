class Guest::OrderItemsController < ApplicationController

  load_and_authorize_resource
  before_action :set_order_item

  attr_reader :order_item
  # Nothing yet (go to /api/)
  
  def set_order_item
    @order_item ||= OrderItem::find(params[:id]) unless params[:id].nil?
  end

  def destroy
    if order_item.delete
      flash[:success] = "Your item was successfully removed."
    else
      flash[:error] = order_item.errors.full_messages.join(', ')
    end
    redirect_to(:back) and return
  end

end