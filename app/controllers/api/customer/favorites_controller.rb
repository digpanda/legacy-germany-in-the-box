class Api::Customer::FavoritesController < Customer::FavoritesController

  # This controller is linked with an APP controller (Customer::FavoritesController)
  def update
    favorites << product
  end

  def destroy
    if favorites.delete(product) # Example of a correct API callback
      render json: {code: "TO DEFINE", error: "Can't remove this product from favorites"}, status: :unprocessable_entity
    end
  end

end