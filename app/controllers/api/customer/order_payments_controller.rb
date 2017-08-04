class Api::Customer::OrderPaymentsController < Api::ApplicationController
  attr_reader :order_payment

  authorize_resource class: false
  before_action :set_order_payment

  def show
    if order_payment
      render json: {success: true, order_payment: order_payment}
      return
    end
    render json: {success: false, error: "Order payment not found."}
  end

  private

    def set_order_payment
      @order_payment = OrderPayment.where(id: params[:id]).first
    end
end
