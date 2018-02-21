class Guest::OrderTrackingsController < ApplicationController
  attr_reader :order_tracking

  before_action :set_order_tracking, only: [:public_url]

  layout :custom_sublayout

  def public_url
    # the public url will go through the normal API unless it's BorderGuru which we have to scrap locally
    # to remove elements.
    redirect_to tracking_handler.api_gateway.public_url(callback_url: navigation.with_url.back(1))
  end

  private

    def tracking_handler
      @tracking_handler ||= TrackingHandler.new(order_tracking)
    end

    def set_order_tracking
      @order_tracking = OrderTracking.find(params[:order_tracking_id] || params[:id])
    end
end
