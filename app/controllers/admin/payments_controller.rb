class Admin::PaymentsController < ApplicationController

  authorize_resource :class => false
  layout :custom_sublayout, only: [:index]
  before_action :set_order_payment, except: [:index]

  attr_reader :order_payment, :order_payments

  def index
    @order_payments = OrderPayment.order_by(c_at: :desc)
  end

  def destroy
    if order_payment.destroy
      flash[:success] = I18n.t(:payment_removed, :notice)
    else
      flash[:error] = order_payment.errors.full_messages.first
    end
    redirect_to :back
  end

  private

  def set_order_payment
    @order_payment = OrderPayment.find(params[:id])
  end

end