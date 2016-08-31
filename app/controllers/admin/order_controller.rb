class Admin::OrdersController < ApplicationController

  load_and_authorize_resource
  before_action :set_order

  attr_accessor :order

  def cancel
    canceller = OrderCanceller.new(order).perform
    if canceller.success?
      flash[:success] = "Order was cancelled successfully."
      redirect_to(:back)
    else
      flash[:error] = "#{canceller.error}"
      redirect_to(:back)
    end
  end

  private

  def set_order
    @order = Order.find(params[:id] || params[:order_id])
  end

end
