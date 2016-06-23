class Customer::FavoritesController < ApplicationController

  # This controller is linked with an API controller (Api::Customer::FavoritesController)
  before_action :authenticate_user!
  attr_reader :favorites, :product

  before_action :set_favorites
  before_action :set_product, only: [:update, :destroy]

  layout :custom_sublayout, only: [:index]

  def index
  end

  def update # handled via API
  end

  def destroy # handled via API
  end

  private

  def set_favorites
    @favorites = current_user.favorites
  end

  def set_product
    @product = Product.find(params[:id])
  end

end