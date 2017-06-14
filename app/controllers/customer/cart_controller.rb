class Customer::CartController < ApplicationController

  attr_accessor :user
  attr_reader :orders

  before_action :freeze_header
  before_action :breadcrumb_cart

  authorize_resource :class => false

  def show
    @orders = cart_manager.orders
  rescue CartManager::Error => error
    flash[:error] = "#{error.message}"
    redirect_to navigation.back(1)
  end

  def edit
  end

  def update
  end

  private

end
