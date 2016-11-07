class Customer::Orders::AddressesController < ApplicationController

  attr_reader :order

  load_and_authorize_resource
  before_action :set_order

  def index
    @addresses = current_user.addresses
  end

  def set_order
    @order = current_user.orders.find(params[:order_id])
  end
  
end
