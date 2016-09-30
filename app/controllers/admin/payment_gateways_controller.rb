class Admin::PaymentGatewaysController < ApplicationController

  load_and_authorize_resource
  before_action :set_payment_gateway, :except => [:index]

  layout :custom_sublayout

  attr_accessor :payment_gateway, :payment_gateways

  def index
  end

  def show
  end

  def update
    if payment_gateway.update(payment_gateway_params)
      flash[:success] = "The payment_gateway was updated."
    else
      flash[:error] = "The payment_gateway was not updated (#{payment_gateway.errors.full_messages.join(', ')})"
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
