require 'csv'
require 'net/ftp'

class Customer::OrdersController < ApplicationController

  authorize_resource :class => false
  before_action :set_order, :except => [:index]
  before_filter :customer_order?, :except => [:index]

  layout :custom_sublayout, only: [:index]

  attr_accessor :order

  def index
    @orders = current_user.orders.nonempty.order_by(:c_at => :desc).paginate(:page => current_page, :per_page => 10)
  end

  # TODO : refactor this
  def show
    @readonly = true
    @currency_code = order.shop.currency.code

    unless order.decorate.bought?

      if order.order_items.count > 0

        begin
          BorderGuru.calculate_quote(order: order)
        rescue Net::ReadTimeout => e
          logger.fatal "Failed to connect to Borderguru: #{e}"
          return nil
        end

      end
    end
  end

  # destroy completely the order or cancel it if has sensitive datas
  # sensitive datas occurs if the customer tries to pay the order itself
  def destroy
    if order.new?
      order.order_items.delete_all
      order.delete
    else
      order.status = :cancelled
      order.save
    end
    flash[:success] = I18n.t(:delete_ok, scope: :edit_order)
    redirect_to navigation.back(1)
  end

  def continue
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
