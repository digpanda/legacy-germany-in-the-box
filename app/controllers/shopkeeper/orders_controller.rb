require 'csv'
require 'net/ftp'

class Shopkeeper::OrdersController < ApplicationController

  CSV_ENCODE = "UTF-8"

  load_and_authorize_resource
  before_action :set_order
  before_filter :is_shop_order

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

  def is_shop_order
    order.shop.id == current_user.shop.id
  end

end
