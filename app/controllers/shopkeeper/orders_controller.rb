require 'csv'
require 'net/ftp'

class Shopkeeper::OrdersController < ApplicationController

  load_and_authorize_resource
  before_action :set_order

  attr_reader :order

  def show
    respond_to do |format|
      format.pdf do
        render pdf: order.id.to_s, disposition: 'attachment'
      end
    end
  end

  def shipped

    if order.is_shippable?
      order.status = :shipped
      order.save
    end

    flash[:success] = "You successfully confirmed having sent this order."
    redirect_to(:back) and return

  end

  def process

    unless order.is_processable?
      flash[:error] = "This order is not processable at the moment. Please try again later."
      redirect_to(:back) and return
    end

    #
    # We start by processing into a CSV file
    #
    csv_file_path = TurnOrderIntoCsvAndStoreIt.new.perform({
      :order => order
    })

    if csv_file_path == false
      flash[:error] = "A problem occured while preparing your order in our server. Please try again."
      redirect_to(:back) and return
    end

    #
    # We transfer the information to BorderGuru
    # We could avoid opening the file twice but it's a double process.
    #
    #file_pushed = PushCsvToBorderguruFtp.perform({
    #  :csv_file_path => csv_file_path
    #})

    #if file_pushed == false
    #  flash[:error] = "A problem occured while transfering your order to BorderGuru. Please try again."
    #  redirect_to(:back) and return
    #end

    #
    # We don't forget to change status of orders and such
    # Only if everything was a success
    #
    order.status = :custom_checking
    order.minimum_sending_date = 1.business_days.from_now
    order.save

    # DONT FORGET TO DEAL WITH MULTIPLE ORDER AND ONLY ONE CSV FILE.

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