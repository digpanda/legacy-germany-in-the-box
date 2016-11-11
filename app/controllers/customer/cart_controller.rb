class Customer::CartController < ApplicationController

  authorize_resource :class => false

  attr_accessor :user
  attr_reader :orders

  def show
    @readonly = false
    @orders = cart_manager.orders
    @shops = Shop.only(:name).where(:id.in => orders.keys).map { |shop| [shop.id.to_s, {:name => shop.name}]}.to_h
  rescue CartManager::Error => e
    flash[:error] = "#{e.message}"
    redirect_to navigation.back(1)
  end

  def edit
  end

  def update
  end

  private

end
