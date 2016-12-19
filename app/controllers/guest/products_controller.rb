class Guest::ProductsController < ApplicationController

  attr_reader :product, :shop

  before_action :set_product, :set_shop

  before_action :breadcrumb_home, only: [:show]
  before_action :breadcrumb_category, :breadcrumb_shop, :breadcrumb_product, only: [:show]

  def show
    @featured_sku = product.decorate.featured_sku.decorate
  end

  private

  def set_product
    @product = Product.where(id: params[:id]).first
    product?
  end

  def product?
    unless product
      flash[:error] = "Product doesn't exist."
      redirect_to navigation.back(1)
    end
  end

  def set_shop
    @shop = product.shop
  end

end
