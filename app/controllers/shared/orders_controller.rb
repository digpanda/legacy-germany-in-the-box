require 'csv'
require 'net/ftp'

class Shared::OrdersController < ApplicationController

  CSV_ENCODE = "UTF-8"

  attr_accessor :order

  authorize_resource :class => false
  before_action :set_order
  before_filter :is_admin_or_shop_order, except: [:label]

  def show
    I18n.locale = :de # TODO : make a helper for that
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
        render pdf: "#{bill_file_name}", disposition: 'attachment'
      end
    end
  end

  # TODO: this is to refactor
  # it was just taken away from
  # a dirty controller for logic purpose
  def label
    response = BorderGuru.get_label(
        border_guru_shipment_id: @order.border_guru_shipment_id
    )

    send_data response.bindata, filename: "#{@order.border_guru_shipment_id}.pdf", type: :pdf

  # to refactor (obviously)
  rescue BorderGuru::Error, SocketError => exception
    Rails.logger.info "Error Download Label Order \##{@order.id} : #{exception.message}"
    throw_app_error(:resource_not_found, {error: "Your label is not ready yet. Please try again in a few hours."})
  end

  def cancel
    canceller = OrderCanceller.new(order).cancel_all!
    if canceller.success?
      flash[:success] = "Order was cancelled successfully."
      redirect_to(:back)
    else
      flash[:error] = "#{canceller.error}"
      redirect_to(:back)
    end
  end

  private

  def bill_file_name
    order.bill_id || order.id
  end

  def set_order
    @order = Order.find(params[:id] || params[:order_id])
  end

  def is_admin_or_shop_order
    current_user.decorate.admin? || order.shop.id == current_user.shop.id
  end

end
