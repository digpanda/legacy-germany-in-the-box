class Admin::OrderPaymentsController < ApplicationController

  load_and_authorize_resource
  #authorize_resource :class => false

  layout :custom_sublayout, only: [:index]
  before_action :set_order_payment, except: [:index]

  attr_reader :order_payment, :order_payments

  def index
    @order_payments = OrderPayment.order_by(c_at: :desc)
  end

  def refund
    refund = WirecardPaymentRefunder.new(order_payment).perform
    if refund.success?
      flash[:success] = "Refund was successful"
    else
      flash[:error] = refund.error.message
    end
    redirect_to navigation.back(1)
  end

  def destroy
    if order_payment.destroy
      flash[:success] = I18n.t(:payment_removed, scope: :notice)
    else
      flash[:error] = order_payment.errors.full_messages.first
    end
    redirect_to navigation.back(1)
  end

  private

  def set_order_payment
    @order_payment = OrderPayment.find(params[:id] || params[:order_payment_id])
  end

end
