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
    @shops = @category.can_buy_shops.compact
    # the logic should be put inside the model here
    @featured_shop = @shops.first
    @casual_shops = @shops # because it can fetch duplicate for no fucking reason.
    @casual_shops.shift
  end

end
