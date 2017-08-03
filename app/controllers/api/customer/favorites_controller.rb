#
# We mainly manipulate the favorites product list via AJAX calls here
#
class Api::Customer::FavoritesController < Api::ApplicationController

  attr_reader :favorites, :product

  authorize_resource class: false

  before_action :set_favorites
  before_action :set_product, only: [:update, :destroy]

  def update
    favorites << product
  end

  def destroy
    unless favorites.delete(product) # Example of a correct API callback
      throw_api_error(:impossible_to_remove, {error: I18n.t(:cannot_remove_from_favorite, scope: :notice)}, :bad_request)
    end
  end

  private

  def set_favorites
    @favorites = current_user.favorites
  end

  def set_product
    @product = Product.find(params[:id])
  end

end
