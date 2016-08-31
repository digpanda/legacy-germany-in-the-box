require 'will_paginate/array'

class Admin::OrderPaymentsController < ApplicationController

  load_and_authorize_resource
  #authorize_resource :class => false

  layout :custom_sublayout, only: [:index]
  before_action :set_order_payment, except: [:index]

  attr_reader :order_payment, :order_payments

  def index
    @order_payments = OrderPayment.order_by(c_at: :desc).paginate(:page => (params[:page] ? params[:page].to_i : 1), :per_page => 10);
  end

  # PATCH
  # when the order payment is stuck on `scheduled` you can manually update the transaction_id
  def transaction_id

    #if order_payment.transaction_id
    #  flash[:error] = "Transaction ID is already present for this payment."
    #  redirect_to navigation.back(1)
    #  return
    #end
    #
    if params["transaction_id"].empty?
      params["transaction_id"] = nil
    end

    order_payment.transaction_id = params["transaction_id"]
    order_payment.status = :scheduled #:unverified
    order_payment.save
    flash[:success] = "Transaction ID was set manually."

    redirect_to navigation.back(1)
    return

  end

  def refund
    refund = payment_refunder.perform
    if refund.success?
      flash[:success] = "Refund was successful"
    else
      flash[:error] = "#{refund.error}"
    end
    redirect_to navigation.back(1)
  end

  # check the order payment through the API and refresh the order matching with it
  # /!\ WARNING : right now the checker first set the payment status to `:unverified`
  # before to call the API which means if we can't establish API communication it can
  # put back the status of the transaction as `:unverified` while it's paid.
  def check
    checker = payment_checker.update_order_payment!
    # it doesn't matter if the API call failed, the order has to be systematically up to date with the order payment in case it's not already sent
    order_payment.order.refresh_status_from!(order_payment)
    if checker.success?
      flash[:success] = "The order was refreshed and seem to be paid."
    else
      flash[:error] = "The order was refreshed but don't seem to be paid. (#{checker.error})"
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

  def payment_refunder
    @payment_refunder ||= WirecardPaymentRefunder.new(order_payment)
  end

  # make API call which refresh order payment
  # TODO : could be refactored to communicate the model directly ? Yes -> UPDATE : should recover most of those arguments via the model itself
  def payment_checker
    @payment_checker ||= WirecardPaymentChecker.new({:transaction_id => order_payment.transaction_id, :merchant_account_id => order_payment.merchant_id, :request_id => order_payment.request_id}.merge({:order_payment => order_payment}))
  end

  def set_order_payment
    @order_payment = OrderPayment.find(params[:id] || params[:order_payment_id])
  end

end
