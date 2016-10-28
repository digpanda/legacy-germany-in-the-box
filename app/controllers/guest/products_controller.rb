class Guest::ProductsController < ApplicationController

  before_action :set_product

  attr_reader :product

  def show
    @featured_sku = @product.decorate.featured_sku.decorate
  end

  private

  def set_product
    @product = Product::find(params[:id])
  end

end
