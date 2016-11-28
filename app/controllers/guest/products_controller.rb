class Guest::ProductsController < ApplicationController

  before_action :set_product, :set_shop

  before_action :breadcrumb_home, only: [:show]
  before_action :breadcrumb_category, :breadcrumb_shop, :breadcrumb_product, only: [:show]

  attr_reader :product, :shop

  def show
    @featured_sku = product.decorate.featured_sku.decorate
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def set_shop
    @shop = product.shop
  end

end
