class Guest::ShopsController < ApplicationController

  before_action :set_shop

  before_action :breadcrumb_home, only: [:show]
  before_action :breadcrumb_category, :breadcrumb_shop, only: [:show]

  attr_reader :shop

  def show
  end

  private

  def set_shop
    @shop = Shop::find(params[:id])
  end

end
