class Customer::Orders::CouponsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_order, :set_coupon

  layout :custom_sublayout

  attr_reader :order, :coupon

  # we apply the coupon to the order
  def create
    if coupon.nil?
      flash[:error] = "This coupon doesn't exist."
      redirect_to navigation.back(1)
      return
    end
    if apply_coupon.success?
      flash[:success] = "The coupon was applied successfully."
    else
      flash[:error] = "The coupon coudln't be applied."
    end
    redirect_to navigation.back(1)
  end

  # unapply the coupon to the order
  def destroy
    redirect_to navigation.back(1)
  end

  private

  def apply_coupon
    CouponHandler.new(coupon, order).apply
  end

  def set_order
    @order = current_user.orders.find(params[:order_id])
  end

  def set_coupon
    @coupon = Coupon.where(code: coupon_params[:code]).first
  end

  def coupon_params
    params.require(:coupon).permit(:code)
  end

end
