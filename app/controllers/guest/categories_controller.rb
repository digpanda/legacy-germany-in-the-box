class Guest::CategoriesController < ApplicationController
  before_filter do
    restrict_to :customer
  end

  attr_reader :category

  before_action :set_category

  def show
    @shops = @category.can_buy_shops.order_by(position: :asc).compact
  end

  private

    def set_category
      @category = Category.find(params[:id])
    end
end
