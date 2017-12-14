class Shopkeeper::ProductsController < ApplicationController
  attr_reader :shop, :products, :product

  authorize_resource class: false

  before_action :set_shop
  before_action :set_product, except: [:index, :new, :create]

  layout :custom_sublayout

  def index
    @products = shop.products.order_by(c_at: :desc).paginate(page: current_page, per_page: 10)
  end

  def new
    @product = shop.products.build
  end

  def create
    @product = shop.products.build(product_params)

    if product.save
      flash[:success] = I18n.t('edit_product.update_ok')
      # we redirect the user directly to the variants setup
      # because it's a new product.
      redirect_to shopkeeper_product_variants_path(product)
      return
    end

    flash[:error] = product.errors.full_messages.join(', ')
    redirect_to navigation.back(1)
  end

  def edit
  end

  def update
    if product.update(product_params)
      flash[:success] = I18n.t('edit_product.update_ok')
      redirect_to edit_shopkeeper_product_path(product)
      return
    end

    flash[:error] = product.errors.full_messages.join(', ')
    redirect_to navigation.back(1)
  end

  def destroy
    if product.destroy
      flash[:success] = I18n.t('edit_product.delete_ok')
    else
      flash[:error] = product.errors.full_messages.join(', ')
    end
    redirect_to navigation.back(1)
  end

  private

    def product_params
      params.require(:product).permit!
    end

    def set_shop
      @shop = current_user.shop
    end

    def set_product
      @product = Product.find(params[:product_id] || params[:id])
    end
end
