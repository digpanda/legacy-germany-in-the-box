class Customer::Orders::AddressesController < ApplicationController

  attr_reader :order, :address, :addresses

  authorize_resource :class => false
  before_action :set_order

  def index
    @addresses = current_user.addresses
    @address = Address.new
  end

  def set_order
    @order = current_user.orders.find(params[:order_id])
  end

end
