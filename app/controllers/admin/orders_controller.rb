class Admin::OrdersController < ApplicationController

  CSV_ENCODE = "UTF-8"

  attr_accessor :order, :orders

  authorize_resource :class => false
  before_action :set_order, :except => [:index]

  layout :custom_sublayout

  before_action :breadcrumb_admin_orders, :except => [:index]
  before_action :breadcrumb_admin_order, only: [:show]

  def index
    respond_to do |format|
      format.html do

        if !params[:status] || params[:status]&.empty?
          @orders = Order.nonempty.order_by(paid_at: :desc, c_at: :desc).paginate(:page => current_page, :per_page => 10)
        else
          @orders = Order.nonempty.order_by(paid_at: :desc, c_at: :desc).where(status: params[:status]).paginate(:page => current_page, :per_page => 10)
        end
      end
      format.csv do
        @orders = Order.nonempty.order_by(paid_at: :desc, c_at: :desc)
        render text: OrdersFormatter.new(orders).to_csv.encode(CSV_ENCODE),
               type: "text/csv; charset=#{CSV_ENCODE}; header=present",
               disposition: 'attachment'
      end
    end
  end

  def show
  end

  def update
    if order.update(order_params)
      flash[:success] = "The order was updated."
    else
      flash[:error] = "The order was not updated (#{order.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  def shipped
    unless order.shippable?
      flash[:error] = "Order is not shippable."
      redirect_to navigation.back(1)
      return
    end

    order.status = :shipped
    order.save
    Notifier::Customer.new(order.user).order_has_been_shipped(order)
    flash[:success] = "Order is considered shipped and SMS was triggered."
    redirect_to navigation.back(1)
  end

  def destroy
    if order.delete
      flash[:success] = "The order was deleted."
    else
      flash[:error] = "The order was not deleted (#{order.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  private

  def set_order
    @order = Order.find(params[:id] || params[:order_id])
  end

  def order_params
    params.require(:order).permit!
  end

end
