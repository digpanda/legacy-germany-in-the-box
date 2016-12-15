# manage all the direct request from customer to border guru API and such
class Customer::Orders::BorderGuruController < ApplicationController

  attr_reader :order
  
  authorize_resource :class => false
  before_action :set_order

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
    @order = current_user.orders.find(params[:order_id])
  end

end
