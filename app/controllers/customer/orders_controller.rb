require 'csv'
require 'net/ftp'

class Customer::OrdersController < ApplicationController

  load_and_authorize_resource
  before_action :set_order, :except => [:index]
  before_filter :is_customer_order, :except => [:index]

  layout :custom_sublayout, only: [:index]

  attr_accessor :order

  def index
    @orders = current_user.orders.nonempty.order_by(:c_at => :desc).paginate(:page => current_page, :per_page => 10);
  end

  private

  def set_order
    @order = Order.find(params[:id] || params[:order_id])
  end

  def is_customer_order
    current_user.orders.where(id: order.id).count
  end

end
