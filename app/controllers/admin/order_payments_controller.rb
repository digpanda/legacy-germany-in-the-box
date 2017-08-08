require 'will_paginate/array'

class Admin::OrderPaymentsController < ApplicationController
  attr_reader :order_payment, :order_payments

  authorize_resource class: false

  layout :custom_sublayout, only: [:index, :show]
  before_action :set_order_payment, except: [:index]

  before_action :breadcrumb_admin_order_payments, except: [:index]
  before_action :breadcrumb_admin_order_payment, only: [:show]

  def index
    @order_payments = OrderPayment.order_by(c_at: :desc).full_text_search(params[:query], match: :all, allow_empty_search: true).paginate(page: current_page, per_page: 10);
  end

  def show
  end

  def update
    if order_payment.update(order_payment_params)
      flash[:success] = 'The order payment was updated.'
    else
      flash[:error] = "The order payment was not updated (#{order.erros.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  def refund
    # Refund has been destroyed because it belongs to Wirecard legacy system.
  end

  def check
    # Check has been destroyed because it belongs to Wirecard legacy system.
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

    def set_order_payment
      @order_payment = OrderPayment.find(params[:id] || params[:order_payment_id])
    end
end
