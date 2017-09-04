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
  # TODO : could be put into a service TrackingHandler to be more clean
  def refresh
    # BIG NOTE : LOGISTIC PARTNER IS HARDCODED AS MKPOST, WE NEED TO CHANGE THAT AFTER (it has to depend on the order)
    tracking = KuaidiApi.new(tracking_id: order.order_tracking&.unique_id, logistic_partner: :mkpost).perform!

    if tracking.success?
      order_tracking.update(
        state: tracking.data[:current_state],
        histories: tracking.data[:current_history],
        refreshed_at: Time.now
      )

      if order_tracking.errors.any?
        flash[:error] = "The tracking was not updated (#{order_tracking.errors.full_messages.join(', ')})"
      else
        flash[:success] = "The tracking was updated successfully."
      end
    else
      flash[:error] = tracking.error
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
      @order_tracking = OrderTracking.find(params[:order_tracking_id])
    end
end
