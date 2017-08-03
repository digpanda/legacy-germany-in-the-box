class Admin::CartsController < ApplicationController

  attr_accessor :cart, :carts

  authorize_resource class: false
  before_action :set_cart, :except => [:index]

  layout :custom_sublayout

  before_action :breadcrumb_admin_carts, :except => [:index]
  before_action :breadcrumb_admin_cart, only: [:show]

  def index
    @carts = Cart.order_by(u_at: :desc).all.paginate(page: current_page, per_page: 10)
  end

  def show
  end

  def update
    if cart.update(cart_params)
      flash[:success] = "The cart was updated."
    else
      flash[:error] = "The cart was not updated (#{cart.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  def destroy
    if cart.delete
      flash[:success] = "The cart was deleted."
    else
      flash[:error] = "The cart was not deleted (#{cart.errors.full_messages.join(', ')})"
    end
    redirect_to admin_carts_path
  end

  private

  def set_cart
    @cart = Cart.find(params[:id] || params[:cart_id])
  end

  def cart_params
    params.require(:cart).permit!
  end

end
