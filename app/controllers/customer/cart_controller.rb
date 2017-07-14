class Customer::CartController < ApplicationController

  attr_accessor :user
  attr_reader :orders

  before_action :freeze_header
  before_action :breadcrumb_cart
  before_action :set_cart

  authorize_resource :class => false

  def show
  end

  private

  def set_cart
    @cart = cart_manager.current_cart
  end

end
