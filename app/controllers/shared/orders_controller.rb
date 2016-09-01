require 'csv'
require 'net/ftp'

class Shared::OrdersController < ApplicationController

  CSV_ENCODE = "UTF-8"

  load_and_authorize_resource
  before_action :set_order
  before_filter :is_admin_or_shop_order

  attr_accessor :order

  def show
    respond_to do |format|
      format.csv do
        render text: BorderGuruFtp::TransferOrders::Makers::Generate.new([order]).to_csv.encode(CSV_ENCODE),
               type: "text/csv; charset=#{CSV_ENCODE}; header=present",
               disposition: 'attachment'
      end
    end
  end

  def bill
    respond_to do |format|
      format.pdf do
        render pdf: order.id.to_s, disposition: 'attachment'
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

  def is_admin_or_shop_order
    current_user.decorate.admin? || order.shop.id == current_user.shop.id
  end

end
