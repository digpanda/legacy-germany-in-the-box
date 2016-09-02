class Admin::OrdersController < ApplicationController

  load_and_authorize_resource
  before_action :set_order, :except => [:index]

  layout :custom_sublayout, only: [:index, :show]

  attr_accessor :order

  def index
    @orders = Order.nonempty.order_by(:c_at => :desc).paginate(:page => current_page, :per_page => 10);
  end

  def show
  end

  def update
  end

  private

  def set_order
    @order = Order.find(params[:id] || params[:order_id])
  end

end
