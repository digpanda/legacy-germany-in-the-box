# all the files output management
class Admin::Orders::DownloadsController < ApplicationController
  CSV_ENCODE = 'UTF-8'.freeze

  attr_reader :orders
  authorize_resource class: false

  layout :custom_sublayout

  before_action :breadcrumb_admin_orders, except: [:index]

  def show
  end

  # entry point for any output
  def create
    # we first get the orders
    @orders = Order.nonempty.where(c_at: date_range).order_by(paid_at: :desc, c_at: :desc)
    # then we call the format method (method csv, official_bills, ...)
    self.send(output_type)
  end

  def csv
    send_data orders_in_csv,
           filename: "#{filename}.csv",
           type: "text/csv; charset=#{CSV_ENCODE}; header=present",
           disposition: 'inline'
  end

  def official_bills
    redirect_to BillsHandler.new(orders).zip
  end

  private

    def filename
      "orders-from-#{start_date}-to-#{end_date}"
    end

    def date_range
      if start_date == end_date
        start_date.beginning_of_day..end_date.end_of_day
      else
        start_date..end_date
      end
    end

    def start_date
      params[:start_date].to_date
    end

    def end_date
      params[:end_date].to_date
    end

    def orders_in_csv
      @orders_in_csv ||= OrdersFormatter.new(orders).to_csv.encode(CSV_ENCODE)
    end

    def set_order
      @order = Order.find(params[:id] || params[:order_id])
    end

    def output_type
      if params[:official_bills]
        :official_bills
      elsif params[:csv]
        :csv
      end
    end
end
