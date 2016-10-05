class Customer::CartController < ApplicationController

  load_and_authorize_resource :class => false
  #before_action :set_user

  attr_accessor :user

  def show
    @readonly = false
    @shops = Shop.only(:name).where(:id.in => cart_manager.orders.keys).map { |shop| [shop.id.to_s, {:name => shop.name}]}.to_h
    @orders = cart_manager.orders
  end

  def edit
  end

  def update
  end

  private

end
