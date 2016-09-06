require 'csv'
require 'net/ftp'

class Customer::OrdersController < ApplicationController

  load_and_authorize_resource
  before_action :set_order, :except => [:index]
  before_filter :customer_order?, :except => [:index]

  layout :custom_sublayout, only: [:index]

  attr_accessor :order

  def index
    @orders = current_user.orders.nonempty.order_by(:c_at => :desc).paginate(:page => current_page, :per_page => 10);
  end

  private

  def set_order
    @order = Order.find(params[:id] || params[:order_id])
  end

  # if it's not the customer order, we prevent him to go further
  def customer_order?
    if Order.where(id: order.id, user_id: current_user.id).first.nil?
      redirect_to navigation.back(1)
      return
    end
  end

end
