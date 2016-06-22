#
# This controller is linked with an APP controller (Customer::FavoritesController)
#
class Api::Customer::FavoritesController < Customer::FavoritesController

  def update
    favorites << product
  end

  def destroy
    unless favorites.delete(product) # Example of a correct API callback
      render status: :bad_request,
             json: throw_error(:impossible_to_remove).merge(error: "Can't remove this product from favorites").to_json and return
    end
  end

end