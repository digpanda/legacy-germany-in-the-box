#
# This controller is linked with an App controller (Customer::FavoritesController)
# We mainly manipulate the favorites product list via AJAX calls here
#
class Api::Customer::FavoritesController < Customer::FavoritesController

  load_and_authorize_resource :class => Product
  
  def update
    binding.pry
    favorites << product
  end

  def destroy
    unless favorites.delete(product) # Example of a correct API callback
      render status: :bad_request,
             json: throw_error(:impossible_to_remove).merge(error: "Can't remove this product from customer favorites").to_json and return
    end
  end

end