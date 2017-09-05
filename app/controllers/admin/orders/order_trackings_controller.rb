class Admin::Orders::OrderTrackingsController < ApplicationController
  attr_accessor :order, :order_tracking

  authorize_resource class: false

  before_action :set_order
  before_action :set_order_tracking, only: [:show, :update, :refresh]

  layout :custom_sublayout

  def index
  end

  def show
  end

  def create
    @order_tracking = OrderTracking.create(order: order)
    update
  end

  def update
    if order_tracking.update(order_tracking_params)
      flash[:success] = 'The order tracking was updated.'
    else
      flash[:error] = "The order tracking was not updated (#{order_tracking.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  # NOTE : it is different from update
  # it calls the API and refresh the model accordingly.
  # there's also a cache maintained
  def refresh
    tracking_handler = TrackingHandler.new(order_tracking).refresh!
    if tracking_handler.success?
      flash[:success] = "Tracking was successfully refreshed"
    else
      flash[:error] = tracking_handler.error
    end
    redirect_to navigation.back(1)
  end

  private

    def order_tracking_params
      params.require(:order_tracking).permit!
    end

    def set_order
      @order = Order.find(params[:order_id])
    end

    def set_order_tracking
      @order_tracking = OrderTracking.find(params[:order_tracking_id] || params[:id])
    end
end
