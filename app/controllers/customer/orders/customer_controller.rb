# we control everything linked to the customer of the order
# this is supposed to be the first step the cart
# and before the checkout
class Customer::Orders::CustomerController < ApplicationController

  attr_reader :order, :customer

  authorize_resource class: false
  before_action :set_order, :set_customer

  # we only check if the customer has all the required datas
  # we go directly to the next step if it's the case
  def show
    return if handle_coupon!
    return if valid_for_checkout?
  end

  private

  def handle_coupon!
    if coupon
      unless apply_coupon.success?
        return coupon_error!
      end
    # if there is no coupon found but the guy tried
    # we rollback and throw an error message
    elsif params[:coupon]
      return coupon_error!
    end
    false
  end

  def valid_for_checkout?
    if customer.valid_for_checkout?
      # we store the current order already
      CheckoutReady.current_order!(session, order)
      redirect_to new_customer_order_address_path(order)
      return true
    end
    false
  end

  def set_customer
    @customer = current_user
  end

  def set_order
    @order = current_user.orders.find(params[:order_id])
  end

  def apply_coupon
    @apply_coupon ||= CouponHandler.new(identity_solver, coupon, order).apply
  end

  def coupon
    @coupon = Coupon.where(code: params[:coupon]).first
  end

  def coupon_error!
    flash[:error] = I18n.t(:applied_fail, scope: :coupon)
    redirect_to navigation.back(1)
    return true
  end

end
