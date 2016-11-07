class Shopkeeper::ProductsController < ApplicationController

  load_and_authorize_resource :class => false
  layout :custom_sublayout, only: [:index]
  before_action :set_shop

  attr_reader :shop, :products

  def index
    @products = current_user.shop.products
  end

  private

  def set_shop
    @shop ||= current_user.shop
  end

end
