class Api::Guest::ProductsController < Api::ApplicationController

  load_and_authorize_resource

  def show_sku

    skus = @product.skus
    skus.each do |sku|
      if sku.option_ids.to_set == params[:option_ids].to_set
        @sku = sku
        return
      end
    end

    render status: :not_found,
           json: throw_error(:unknown_id).merge(error: "Sku not found.").to_json and return
    return

  end

end