class Api::Guest::ProductsController < Guest::ProductsController

  load_and_authorize_resource

  def show_sku

    skus = @product.skus
    skus.each do |sku|
      if sku.option_ids.to_set == params[:option_ids].to_set
        @sku = sku
        return
      end
    end

    render :json => { :success => false, :error => "Not found" }, :status => :not_found
    return

  end

end