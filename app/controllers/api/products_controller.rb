class Api::ProductsController < ProductsController

  before_action :authenticate_user!, except: [:get_sku_for_options]

  before_action :set_product, only: [:get_sku_for_options]

  def like
    @product = Product.find(params[:id])
    @favorites =  current_user.favorites
    @favorites << @product
  end

  def unlike
    @product = Product.find(params[:id])
    @favorites = current_user.favorites
    @favorites.delete(@product)
  end

  def get_sku_for_options

    skus = @product.skus
    skus.each do |s|
      if s.option_ids.to_set == params[:option_ids].to_set
        @sku = s
        render :show_sku, locals: { sku: s }, :status => :ok
        return
      end
    end

    # Shoule be improved and normed - Laurent
    render :json => {}, :status => :not_found
    return

  end

end