# manage all the direct request from customer to border guru API and such
class Customer::Orders::BorderGuruController < ApplicationController

  attr_reader :order

  before_action :authenticate_user!
  before_action :set_order
  before_filter :customer_order?

  # get the border guru tracking id from API call or the model itself
  def tracking_id
    if order.border_guru_link_tracking
      redirect_to order.border_guru_link_tracking
      return
    end
    if track!.success?
      redirect_to order.border_guru_link_tracking
    else
      flash[:error] = "We can't recover your tracking ID. Try again in a few minutes."
      redirect_to navigation.back(1)
    end
  end

  private

  def track!
    @track ||= BorderGuruApiHandler.new(order).get_shipping!
  end

  def set_order
    @order = Order.find(params[:order_id])
  end

  # if it's not the customer order, we prevent him to go further
  def customer_order?
    if Order.where(id: order.id, user_id: current_user.id).first.nil?
      redirect_to navigation.back(1)
      return
    end
  end

end
