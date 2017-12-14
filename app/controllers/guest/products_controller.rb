class Guest::ProductsController < ApplicationController
  before_filter do
    restrict_to :customer
  end

  attr_reader :product, :shop, :featured_sku

  before_action :set_product, :set_shop
  before_action :set_featured_sku, only: [:show]
  before_filter :valid_featured_sku?

  def show
    @other_products = shop.products.not_in(_id: [product.id]).highlight_first.can_buy.by_brand.limit(6)
  end

  private

    def valid_featured_sku?
      unless featured_sku
        flash[:error] = I18n.t('featured_sku.not_ready_yet')
        redirect_to navigation.back(1)
        return false
      end
      true
    end

    def set_featured_sku
      @featured_sku = product.decorate.featured_sku&.decorate
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def set_shop
      @shop = product.shop
    end
end
