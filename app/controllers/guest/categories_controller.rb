class Guest::CategoriesController < ApplicationController

  attr_reader :category

  before_action :set_category

  before_action :breadcrumb_home, only: [:show]
  before_action :breadcrumb_category, only: [:show]

  def show
    @shops = @category.can_buy_shops.compact
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

end
