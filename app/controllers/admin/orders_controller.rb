class Admin::OrdersController < ApplicationController

  load_and_authorize_resource
  before_action :set_order

  attr_accessor :order

  # Check Shared::OrdersController
  # It was moved there.

  private

  def set_order
    @order = Order.find(params[:id] || params[:order_id])
  end

end
