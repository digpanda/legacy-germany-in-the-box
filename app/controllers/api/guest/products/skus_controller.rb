class Api::Guest::Products::SkusController < Api::ApplicationController
  attr_reader :product, :skus, :sku

  before_action :set_product
  before_action :set_skus, only: [:index]
  before_action :set_sku, only: [:show]

  def index
    return if skus

    render status: :not_found,
           json: throw_error(:unknown_id).merge(error: I18n.t(:sku_not_found, scope: :notice)).to_json
  end

  def show
    return if sku

    render status: :not_found,
           json: throw_error(:unknown_id).merge(error: I18n.t(:sku_not_found, scope: :notice)).to_json
  end

  private

      def set_product
        @product = Product.find(params[:product_id]).decorate
      end

      def set_skus
        @skus = product.skus
      end

      def set_sku
        @sku = product.sku_from_option_ids(params[:option_ids])
      end
end
