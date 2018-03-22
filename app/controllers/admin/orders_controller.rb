# order management from the admin dashboard
class Admin::OrdersController < ApplicationController
  attr_reader :order, :orders

  authorize_resource class: false
  before_action :set_order, except: [:index, :ongoing, :official_bills]
  before_action :set_order_tracking, only: [:show]

  layout :custom_sublayout

  before_action :breadcrumb_admin_orders, except: [:index]
  before_action :breadcrumb_admin_order, only: [:show]

  def index
    @orders = Order.nonempty.order_by(paid_at: :desc, c_at: :desc).full_text_search(params[:query]).paginate(page: current_page, per_page: 100)
  end

  def ongoing
    @orders = Order.ongoing.full_text_search(params[:query])
                           .paginate(page: current_page, per_page: 100)
  end

  def show
  end

  def update
    if order.update(order_params)
      flash[:success] = 'The order was updated.'
    else
      flash[:error] = "The order was not updated (#{order.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  def terminate
    order.update(status: :terminated)
    flash[:success] = 'Order has been terminated.'
    redirect_to navigation.back(1)
  end

  def shipped
    if order.shippable?
      ship_order
      flash[:success] = 'Order is considered shipped and SMS was triggered.'
    else
      flash[:error] = 'Order is not shippable.'
    end
    redirect_to navigation.back(1)
  end

  def destroy
    if order.delete
      flash[:success] = 'The order was deleted.'
    else
      flash[:error] = "The order was not deleted (#{order.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  private

    def ship_order
      order.update(status: :shipped)
      Notifier::Customer.new(order.user).order_has_been_shipped(order)
    end

    def set_order
      @order = Order.find(params[:id] || params[:order_id])
    end

    def set_order_tracking
      @order_tracking= begin
        OrderTracking.where(order: order).first || OrderTracking.create(order: order, histories: [])
      end
    end

    def order_params
      params.require(:order).permit!
    end
end
