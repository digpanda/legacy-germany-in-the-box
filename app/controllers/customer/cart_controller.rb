class Customer::CartController < ApplicationController

  load_and_authorize_resource :class => false
  #before_action :set_user

  attr_accessor :user

  def show
    @readonly = false
    @shops = Shop.only(:name).where(:id.in => current_orders.keys).map { |shop| [shop.id.to_s, {:name => shop.name}]}.to_h
    @carts = current_carts
  end

  def edit
  end

  def update
  end

  private

end
