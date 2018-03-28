require 'csv'
require 'net/ftp'

class Guest::OrdersController < ApplicationController
  attr_reader :order
  before_action :set_order

  def official_bill
    respond_to do |format|
      format.pdf do
        render pdf: "#{bill_file_name}", disposition: disposition,
               margin: { bottom: 30, top: 30, right: 5, left: 5 },
               footer: { html: { template: 'layouts/pdf/footer.pdf.erb' } },
               header: { html: { template: 'layouts/pdf/header.pdf.erb' } }
      end
    end
  end

  private

    def disposition
      @disposition ||= params[:disposition] || 'attachment' # e.g. inline
    end

    def bill_file_name
      order.bill_id || order.id
    end

    def set_order
      @order = Order.find(params[:id] || params[:order_id])
    end
end
