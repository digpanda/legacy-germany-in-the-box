class Guest::OrderItemsController < ApplicationController

  load_and_authorize_resource
  before_action :set_order_item

  attr_reader :order_item

  def destroy
    if order_item.delete
      flash[:success] = I18n.t(:item_removed, :notice)
    else
      flash[:error] = order_item.errors.full_messages.join(', ')
    end
    redirect_to(:back) and return
  end

  private

  def set_order_item
    @order_item = OrderItem::find(params[:id]) unless params[:id].nil?
  end

end