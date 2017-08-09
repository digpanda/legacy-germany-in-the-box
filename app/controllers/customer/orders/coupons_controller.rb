class Customer::Orders::CouponsController < ApplicationController
  attr_reader :order, :coupon

  authorize_resource class: false
  before_action :set_order
  before_action :set_coupon, except: [:destroy]

  layout :custom_sublayout

  # we apply the coupon to the order
  def create
    if coupon.nil?
      flash[:error] = I18n.t('coupon.applied_fail')
      redirect_to navigation.back(1)
      return
    end
    if apply_coupon.success?
      flash[:success] = I18n.t('coupon.applied_successfully')
    else
      flash[:error] = "#{apply_coupon.error}"
    end
    redirect_to navigation.back(1)
  end

  # unapply the coupon to the order
  def destroy
    unless order.coupon.nil?
      unless unapply_coupon.success?
        flash[:error] = "#{unapply_coupon.error}"
      end
    end
    redirect_to navigation.back(1)
  end

  private

    def unapply_coupon
      @unapply_coupon ||= CouponHandler.new(identity_solver, order.coupon, order).unapply
    end

    def apply_coupon
      @apply_coupon ||= CouponHandler.new(identity_solver, coupon, order).apply
    end

    def set_order
      @order = current_user.orders.find(params[:order_id])
    end

    def set_coupon
      @coupon = Coupon.where(code: coupon_params[:code].strip).first
    end

    def coupon_params
      params.require(:coupon).permit(:code)
    end
end
