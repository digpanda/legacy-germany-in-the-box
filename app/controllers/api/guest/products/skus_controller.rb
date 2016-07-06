class Api::Guest::Products::SkusController < Api::ApplicationController

  before_action :set_product

  def show

    # Refactor and test this.
    skus = @product.skus
    skus.each do |sku|
      if sku.option_ids.to_set == params[:option_ids].to_set
        @sku = sku
        return
      end
    end

    render status: :not_found,
           json: throw_error(:unknown_id).merge(error: "Sku not found.").to_json and return

  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

end