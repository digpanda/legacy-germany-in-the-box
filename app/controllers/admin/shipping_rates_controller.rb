class Admin::ShippingRatesController < ApplicationController
  attr_reader :shipping_rate, :shipping_rates

  authorize_resource class: false
  before_action :set_shipping_rate, only: [:update]

  layout :custom_sublayout

  def index
    @shipping_rates ||= ShippingRate.all
  end

  def update
    if shipping_rate.update(shipping_rate_params)
      flash[:success] = 'The shipping rate was updated.'
      redirect_to admin_shipping_rates_path
    else
      flash[:error] = "The shipping rate was not updated (#{shipping_rate.errors.full_messages.join(', ')})"
      render :new
    end
  end

  private

    def set_shipping_rate
      @shipping_rate ||= ShippingRate.find(params[:id])
    end

    def shipping_rate_params
      params.require(:shipping_rate).permit!
    end
end
