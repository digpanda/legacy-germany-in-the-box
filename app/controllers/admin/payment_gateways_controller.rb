class Admin::PaymentGatewaysController < ApplicationController

  attr_accessor :payment_gateway, :payment_gateways

  authorize_resource class: false
  before_action :set_payment_gateway, :except => [:index]

  layout :custom_sublayout

  def index
  end

  def show
  end

  def update
    if payment_gateway.update(payment_gateway_params)
      flash[:success] = "The payment gateway was updated."
    else
      flash[:error] = "The payment gateway was not updated (#{payment_gateway.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  def destroy
    if payment_gateway.destroy
      flash[:success] = "The payment gateway account was successfully destroyed."
    else
      flash[:error] = "The payment gateway was not destroyed (#{payment_gateway.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  private

  def set_payment_gateway
    @payment_gateway = PaymentGateway.find(params[:id] || params[:payment_gateway_id])
  end

  def payment_gateway_params
    params.require(:payment_gateway).permit!
  end

end
