#
# This controller is linked with an APP controller (Customer::FavoritesController)
#
class Api::Customer::FavoritesController < Customer::FavoritesController

  def update
    favorites << product
  end

  def destroy
    unless favorites.delete(product) # Example of a correct API callback
      render json: {code: "TO DEFINE", error: "Can't remove this product from favorites"}, status: :unprocessable_entity
    end
  end

end