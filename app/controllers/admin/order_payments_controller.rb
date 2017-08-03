require 'will_paginate/array'

class Admin::OrderPaymentsController < ApplicationController

  attr_reader :order_payment, :order_payments

  authorize_resource class: false

  layout :custom_sublayout, only: [:index, :show]
  before_action :set_order_payment, except: [:index]

  before_action :breadcrumb_admin_order_payments, :except => [:index]
  before_action :breadcrumb_admin_order_payment, only: [:show]

  def index
    @order_payments = OrderPayment.order_by(c_at: :desc).full_text_search(params[:query], match: :all, allow_empty_search: true).paginate(page: current_page, per_page: 10);
  end

  def show
  end

  def update
    if order_payment.update(order_payment_params)
      flash[:success] = "The order payment was updated."
    else
      flash[:error] = "The order payment was not updated (#{order.erros.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
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

  def order_payment_params
    params.require(:order_payment).permit!
  end

  def payment_refunder
    @payment_refunder ||= WirecardPaymentRefunder.new(order_payment)
  end

  # make API call which refresh order payment
  def payment_checker
    @payment_checker ||= WirecardPaymentChecker.new({:order_payment => order_payment})
  end

  def set_order_payment
    @order_payment = OrderPayment.find(params[:id] || params[:order_payment_id])
  end

end
