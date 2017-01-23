class Guest::ShopsController < ApplicationController

  attr_reader :shop

  before_action :set_shop, :set_products

  before_action :breadcrumb_home, only: [:show]
  before_action :breadcrumb_category, :breadcrumb_shop, only: [:show]

  def show
  end

  private

  def set_shop
    @shop = Shop::find(params[:id])
  end

  def set_products
    if from_category
      @products = shop.products.where(category_ids: from_category).can_buy.by_brand
    else
      @products = shop.products.can_buy.by_brand
    end
  end

  def from_category
    params[:category_id]
  end

end
