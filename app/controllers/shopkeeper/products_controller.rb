class Shopkeeper::ProductsController < ApplicationController

  load_and_authorize_resource

  before_action :set_shop
  before_action :set_product, except: [:index, :new, :create]

  layout :custom_sublayout

  attr_reader :shop, :products, :product

  def index
    @products = current_user.shop.products
  end

  def new
    # NOTE : not sure this is used in the system actually
    setup_categories_options!
    @product = shop.products.build
  end

  def create

    @product = shop.products.build(product_params)

    if product.save
      flash[:success] = I18n.t(:update_ok, scope: :edit_product)
      redirect_to shopkeeper_products_path
      return
    end

    flash[:error] = product.errors.full_messages.first
    redirect_to navigation.back(1)

  end

  def edit
    setup_categories_options!
  end

  def update

    if @product.update(product_params)
      flash[:success] = I18n.t(:update_ok, scope: :edit_product)
      redirect_to edit_shopkeeper_product_path(product)
      return
    end

    flash[:error] = product.errors.full_messages.first
    redirect_to navigation.back(1)

  end

  def destroy
    sid = product.shop.id
    if @product.destroy
      flash[:success] = I18n.t(:delete_ok, scope: :edit_product)
      redirect_to show_products_shop_path(sid)
    else
      flash[:error] = product.errors.full_messages.first
      redirect_to show_products_shop_path(sid)
    end
  end

  private

  def setup_categories_options!
    @customer_categories_options = DutyAndCustomerCategorySelectStore.new(Category.name)
    @duty_categories_options = DutyAndCustomerCategorySelectStore.new(DutyCategory.name)
  end

  # TODO : this is fat and disgusting
  # it should be refactored entirely
  def product_params
    delocalize_config = { skus_attributes: { :price => :number,:space_length => :number, :space_width => :number, :space_height => :number, :discount => :number, :quantity => :number, :weight => :number} }

    # NOTE TODO : THIS WILL BE PLACED WHEN WE DO THE ADMIN SECTION OF PRODUCTS
    if current_user.decorate.admin?
      params.require(:product)[:category_ids] = [params.require(:product)[:category_ids]] unless params.require(:product)[:category_ids].nil?
      shopkeeper_strong_params += [:duty_category, category_ids:[]]
    end

    # TODO : THIS DOES NOT SEEM TO HAVE IMPACT ANYWHERE ON THE SYSTEM
    # PLEASE TEST IT AND CHANGE IT ACCORDINGLY
    if sku_attributes = params.require(:product)[:skus_attributes]
      sku_attributes.each do |k,v|
        v[:option_ids] = v[:option_ids].reject { |c| c.empty? }
      end
    end

    params.require(:product).permit!.delocalize(delocalize_config)
  end

  def set_shop
    @shop = current_user.shop
  end

  def set_product
    @product = Product.find(params[:id])
  end

end
