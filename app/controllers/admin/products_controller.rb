class Admin::ProductsController < ApplicationController

  attr_reader :shop, :products, :product

  authorize_resource class: false

  before_action :set_product, except: [:index]

  layout :custom_sublayout

  def index
    @products = Product.order_by(c_at: :desc).full_text_search(query, match: :all, allow_empty_search: true).paginate(page: current_page, per_page: 10)
  end

  private

    def query
      params.require(:query) if params[:query].present?
    end

    def set_product
      @product = Product.find(params[:product_id] || params[:id])
    end
end
