class Guest::OrderItemsController < ApplicationController

  load_and_authorize_resource
  before_action :set_order_item

  # Nothing yet (go to /api/)
  
  def set_order_item
    @order_item ||= OrderItem::find(params[:id]) unless params[:id].nil?
  end

end