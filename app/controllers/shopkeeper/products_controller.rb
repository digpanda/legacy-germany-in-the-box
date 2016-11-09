class Shopkeeper::ProductsController < ApplicationController

  load_and_authorize_resource

  before_action :set_shop
  before_action :set_product, except: [:index, :new, :create]

  layout :custom_sublayout

  attr_reader :shop, :products, :product

  def index
    @products = current_user.shop.products.order_by(:c_at => :desc).paginate(:page => current_page, :per_page => 10)
  end

  def new
    @product = shop.products.build
  end

  def create
    @product = shop.products.build(product_params)

    if product.save
      flash[:success] = I18n.t(:update_ok, scope: :edit_product)
      redirect_to shopkeeper_products_path
      return
    end

    flash[:error] = product.errors.full_messages.join(', ')
    redirect_to navigation.back(1)
  end

  def edit
  end

  def update
    if product.update(product_params)
      flash[:success] = I18n.t(:update_ok, scope: :edit_product)
      redirect_to edit_shopkeeper_product_path(product)
      return
    end

    flash[:error] = product.errors.full_messages.first
    redirect_to navigation.back(1)
  end

  def destroy
    if product.destroy
      flash[:success] = I18n.t(:delete_ok, scope: :edit_product)
      redirect_to shopkeeper_shop_path
      return
    end
    flash[:error] = product.errors.full_messages.first
    redirect_to shopkeeper_shop_path
  end

  private

  def product_params
    # NOTE TODO : THIS WILL BE PLACED WHEN WE DO THE ADMIN SECTION OF PRODUCTS
    # NOTE 2 : THIS LOOKS ACTUALLY COMPLETELY USELESS AT THE END.
    # if current_user.decorate.admin?
    #   params.require(:product)[:category_ids] = [params.require(:product)[:category_ids]] unless params.require(:product)[:category_ids].nil?
    #   shopkeeper_strong_params += [:duty_category, category_ids:[]]
    # end
    params.require(:product).permit!
  end

  def set_shop
    @shop = current_user.shop
  end

  def set_product
    @product = Product.find(params[:id])
  end

end
