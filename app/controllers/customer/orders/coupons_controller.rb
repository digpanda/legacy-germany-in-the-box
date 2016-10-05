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
    end
  end

  # unapply the coupon to the order
  def destroy
    redirect_to navigation.back(1)
  end

  private

  def set_order
    @order = current_user.orders.find(params[:order_id])
  end

  def set_coupon
    @coupon = Coupon.where(code: params[:code]).first
  end

end
