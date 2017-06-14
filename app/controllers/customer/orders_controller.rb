require 'csv'
require 'net/ftp'

class Customer::OrdersController < ApplicationController

  attr_accessor :order

  authorize_resource :class => false
  before_action :set_order, :except => [:index]
  before_filter :customer_order?, :except => [:index]

  layout :custom_sublayout, only: [:index]

  def index
    @orders = current_user.orders.nonempty.order_by(:c_at => :desc).paginate(:page => current_page, :per_page => 10)
  end

  def show
  end

  # destroy completely the order or cancel it if has sensitive datas
  # sensitive datas occurs if the customer tries to pay the order itself
  def destroy
    if order.new?
      # this won't trigger the before_destroy validation, don't forget
      order.order_items.delete_all
      order.order_payments.delete_all
      order.delete
    else
      OrderCanceller.new(order).all!
      # we refresh the cart manager (this should remove the entry)
      cart_manager.refresh!
    end
    flash[:success] = I18n.t(:delete_ok, scope: :edit_order)
    redirect_to navigation.back(1)
  end

  def continue
    order.status = :new
    order.save
    cart_manager.store(order)
    redirect_to customer_cart_path
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
