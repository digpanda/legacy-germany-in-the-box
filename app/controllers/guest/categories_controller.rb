class Guest::CategoriesController < ApplicationController

  attr_reader :category

  before_action :set_category

  before_action :breadcrumb_home, only: [:show]
  before_action :breadcrumb_category, only: [:show]

  def show
  end

  private

  def set_category
    @category = Category.find(params[:id])
    @shops = @category.can_buy_shops
    @featured_shop = @category.can_buy_shops.uniq.compact.first
    @casual_shops = @category.can_buy_shops.uniq.compact # because it can fetch duplicate for no fucking reason.
    @casual_shops.shift
  end

end
