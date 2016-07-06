class Api::Guest::Products::SkusController < Api::ApplicationController

  attr_reader :product
  before_action :set_product

  def show

    @sku = product.sku_from_option_ids(params[:option_ids])
    return unless @sku

    render status: :not_found,
           json: throw_error(:unknown_id).merge(error: "Sku not found.").to_json and return

  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

end