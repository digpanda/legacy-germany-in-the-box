class Api::Guest::Products::SkusController < Api::ApplicationController

  attr_reader :product
  
  before_action :set_product

  def show

    @sku = product.sku_from_option_ids(params[:option_ids])
    return if @sku

    render status: :not_found,
           json: throw_error(:unknown_id).merge(error: I18n.t(:sku_not_found, scope: :notice)).to_json

  end

  private

  def set_product
    @product = Product.find(params[:product_id]).decorate
  end

end
