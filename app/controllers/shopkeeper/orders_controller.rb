class Shopkeeper::OrdersController < ApplicationController

  load_and_authorize_resource
  before_action :set_order

  attr_reader :order

  def show_pdf
    respond_to do |format|
      format.pdf do
        render pdf: order.id.to_s, disposition: 'attachment' # name of the pdf
      end
    end
  end

  private

  def set_order
    @order ||= Order.find(params[:id])
  end
end