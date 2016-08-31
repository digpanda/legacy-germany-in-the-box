class Admin::OrdersController < ApplicationController

  load_and_authorize_resource
  before_action :set_order

  attr_accessor :order

  def show
    respond_to do |format|
      format.pdf do
        OrderDisplay.new(order).render_to_pdf
      end
      format.csv do
        OrderDisplayer.new(order).render_to_csv
      end
    end
  end

  def bill
    respond_to do |format|
      format.pdf do
        OrderDisplay.new(order).render_to_pdf
      end
    end
  end

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
