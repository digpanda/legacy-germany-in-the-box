require 'csv'
require 'net/ftp'

class Shopkeeper::OrdersController < ApplicationController

  CSV_ENCODE = "UTF-8"

  load_and_authorize_resource
  before_action :set_order
  #before_filter :is_shop_order

  attr_accessor :order

  def show
    respond_to do |format|
      format.pdf do
        render pdf: order.id.to_s, disposition: 'attachment'
      end
      format.csv do
        I18n.locale = :de # force german for CSV
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

  def shipped

    if order.decorate.shippable?
      order.status = :shipped
      order.save
    end

    flash[:success] = I18n.t(:order_sent, scope: :notice)
    redirect_to(:back)
    return

  end

  def process_order # can't just put `process` it seems to be reserved term in Rails

    unless order.decorate.processable?
      flash[:error] = I18n.t(:order_not_processable, scope: :notice)
      redirect_to(:back)
      return
    end

    # we don't forget to change status of orders and such
    # only if everything was a success
    order.status = :custom_checkable
    order.save

    # we go back now
    flash[:success] = I18n.t(:order_processing, scope: :notice)
    redirect_to(:back)
    return

  end

  def cancel

    unless order.decorate.cancellable?
      flash[:error] = "Impossible to cancel order"
      redirect_to(:back)
      return
    end

    # we cancel the order
    order.status = :cancelled
    order.save

    # we go back now
    flash[:success] = "Order was cancelled successfully."
    redirect_to(:back)
    return

  end

  private

  def set_order
    @order ||= Order.find(params[:id] || params[:order_id])
  end

  def is_shop_order
  end

end
