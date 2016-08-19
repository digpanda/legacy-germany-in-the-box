require 'csv'
require 'net/ftp'

class Shopkeeper::OrdersController < ApplicationController

  CSV_ENCODE = "UTF-8"

  load_and_authorize_resource
  before_action :set_order

  attr_reader :order

  def show
    respond_to do |format|
      format.pdf do
        render pdf: order.id.to_s, disposition: 'attachment'
      end
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

  def shipped

    if order.shippable?
      order.status = :shipped
      order.save
    end

    flash[:success] = I18n.t(:order_sent, scope: :notice)
    redirect_to(:back)
    return

  end

  def process_order # keyword `process` used for obscure reasons

    unless order.processable?
      flash[:error] = I18n.t(:order_not_processable, scope: :notice)
      redirect_to(:back)
      return
    end

    #
    # We don't forget to change status of orders and such
    # Only if everything was a success
    #
    order.status = :custom_checking
    order.minimum_sending_date = 1.business_days.from_now
    order.save

    #
    # We go back now
    #
    flash[:success] = I18n.t(:order_processing, scope: :notice)
    redirect_to(:back)
    return

  end

  private

  def set_order
    @order ||= Order.find(params[:id] || params[:order_id])
  end
end
