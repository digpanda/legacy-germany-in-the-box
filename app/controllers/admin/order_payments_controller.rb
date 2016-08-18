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
    if payment_refunder.perform.success?
      flash[:success] = "Refund was successful"
    else
      flash[:error] = payment_refunder.error.message
    end
    redirect_to navigation.back(1)
  end

  def check
    if payment_checker.success?
      flash[:success] = "The order was refreshed and seem to be paid."
    else
      flash[:error] = "The order was refreshed but don't seem to be paid. (#{checker.data})"
    end
    # it doesn't matter if the API call failed, the order has to be systematically up to date with the order payment in case it's not already sent
    order_payment.order.refresh_order_from!(order_payment)
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

  def payment_refunder
    @payment_refunder ||= WirecardPaymentRefunder.new(order_payment)
  end
  # make API call which refresh order payment
  # TODO : could be refactored to communicate the model directly ? Yes
  def payment_checker
    @payment_checker ||= WirecardPaymentChecker.new({:transaction_id => order_payment.transaction_id, :merchant_account_id => order_payment.merchant_id, :request_id => order_payment.request_id}).update_order_payment!
  end

  def set_order_payment
    @order_payment = OrderPayment.find(params[:id] || params[:order_payment_id])
  end

end
