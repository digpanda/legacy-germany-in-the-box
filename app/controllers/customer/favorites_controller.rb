# This controller is linked with an API controller (Api::Customer::FavoritesController)
# If you change something basic here, don't forget to add it to the API if needed.
class Customer::FavoritesController < ApplicationController
  attr_reader :favorites, :product

  authorize_resource class: false

  before_action :set_favorites

  layout :custom_sublayout, only: [:index]

  def index
  end

  private

    def set_favorites
      @favorites = current_user.favorites.has_available_sku
    end

    def set_product
      @product = Product.find(params[:id])
    end
end
