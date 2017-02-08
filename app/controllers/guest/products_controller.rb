class Guest::ProductsController < ApplicationController

  before_filter do
    restrict_to :customer
  end
  
  attr_reader :product, :shop

  before_action :set_product, :set_shop

  before_action :breadcrumb_home, only: [:show]
  before_action :breadcrumb_category, :breadcrumb_shop, :breadcrumb_product, only: [:show]

  def show
    @featured_sku = product.decorate.featured_sku.decorate
    @other_products = shop.products.not_in(:_id => [product.id]).highlight_first.can_buy.by_brand.limit(6)
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def set_shop
    @shop = product.shop
  end

end
