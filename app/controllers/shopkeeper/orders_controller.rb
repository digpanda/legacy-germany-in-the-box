require 'csv'
require 'net/ftp'

class Shopkeeper::OrdersController < ApplicationController

  load_and_authorize_resource
  before_action :set_order

  CSV_ENCODE = "iso-8859-1"

  attr_reader :order

  def show
    respond_to do |format|
      format.pdf do
        render pdf: order.id.to_s, disposition: 'attachment'
      end
      format.csv do
        render text: TurnOrdersIntoCsvAndStoreIt.new(order.shop, [order]).turn_orders.encode(CSV_ENCODE),
               type: "text/csv; charset=#{CSV_ENCODE}; header=present", 
               disposition: 'attachment'
      end
    end
  end

  def shipped

    if order.shippable?
      order.status = :shipped
      order.save
    end

    flash[:success] = "You successfully confirmed having sent this order."
    redirect_to(:back) and return

  end

  def process_order # keyword `process` used for obscure reasons

    unless order.processable?
      flash[:error] = "This order is not processable at the moment. Please try again later."
      redirect_to(:back) and return
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
    flash[:success] = "Your order is being processed by our partner. You'll soon be able to send it out."
    redirect_to(:back) and return

  end

  private

  def set_order
    @order ||= Order.find(params[:id] || params[:order_id])
  end
end