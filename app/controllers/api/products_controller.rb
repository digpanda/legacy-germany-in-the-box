class Api::ProductsController < ProductsController

  before_action :authenticate_user!, except: [:get_sku_for_options]

  before_action :set_product

  def like
    @favorites =  current_user.favorites
    @favorites << @product
  end

  def unlike
    @favorites = current_user.favorites
    @favorites.delete(@product)
  end

end