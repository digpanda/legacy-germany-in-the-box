class Admin::Orders::OrderTrackingsController < ApplicationController
  attr_reader :order, :order_tracking

  authorize_resource class: false

  before_action :set_order
  before_action :set_order_tracking, only: [:show, :update, :refresh, :public_tracking]

  layout :custom_sublayout

  def index
  end

  def show
  end

  def create
    @order_tracking = OrderTracking.create(order: order)
    SlackDispatcher.new.message("THIS IS THE ORDER #{order}")
    SlackDispatcher.new.message("YO ORDER TRACKING : #{order_tracking}")
    update
  end

  def update
    SlackDispatcher.new.message("ORDER TRACKING ALREADY HERE #{order_tracking.id}")
    SlackDispatcher.new.message("DATA WE ALREADY HAVE : #{order_tracking.delivery_id}")
    SlackDispatcher.new.message("PARAMS : #{params}")
    SlackDispatcher.new.message("PARAMS ORDER TRACKING : #{order_tracking_params}")
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
    tracking = tracking_handler.refresh!
    if tracking.success?
      flash[:success] = 'Tracking was successfully refreshed'
    else
      flash[:error] = tracking.error
    end
    redirect_to navigation.back(1)
  end

  def public_tracking
    redirect_to guest_order_tracking_public_url_path(order_tracking)
  end

  private

    def tracking_handler
      @tracking_handler ||= TrackingHandler.new(order_tracking)
    end

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
