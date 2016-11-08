# this section might be temporary and is reserved for shopkeepers and admin only
# it's the administration of the products and their settings
# we should split it up into two different section
# with different way of displaying the information
class Shared::ProductsController < ApplicationController

  load_and_authorize_resource

  before_filter :is_admin_or_shop_order
  before_action :set_shop
  before_action :set_product, except: [:index, :new, :create]

  layout :custom_sublayout

  attr_reader :shop, :products, :product

  def index
    @products = current_user.shop.products
  end

  def new
    @product = shop.products.build
    @customer_categories_options = DutyAndCustomerCategorySelectStore.new(Category.name)
    @duty_categories_options = DutyAndCustomerCategorySelectStore.new(DutyCategory.name)
  end

  def create

    if sku_attributes = params.require(:product)[:skus_attributes]
      sku_attributes.each do |k,v|
        v[:option_ids] = v[:option_ids].reject { |c| c.empty? }
      end
    end

    if Product.create(product_params)
      flash[:success] = I18n.t(:update_ok, scope: :edit_product)
      redirect_to shared_products_path
      return
    end

    flash[:error] = @product.errors.full_messages.first
    redirect_to navigation.back(1)

  end

  def edit
    @customer_categories_options = DutyAndCustomerCategorySelectStore.new(Category.name)
    @duty_categories_options = DutyAndCustomerCategorySelectStore.new(DutyCategory.name)
  end

  def update

    if sku_attributes = params.require(:product)[:skus_attributes]
      sku_attributes.each do |k,v|
        v[:option_ids] = v[:option_ids].reject { |c| c.empty? }
      end
    end

    if @product.update(product_params)
      flash[:success] = I18n.t(:update_ok, scope: :edit_product)
      redirect_to edit_shared_product_path(product)
      return
    end

    flash[:error] = @product.errors.full_messages.first
    redirect_to navgiation.back(1)

  end

  def destroy
    sid = @product.shop.id
    if @product.destroy
      flash[:success] = I18n.t(:delete_ok, scope: :edit_product)
      redirect_to show_products_shop_path(sid)
    else
      flash[:error] = @product.errors.full_messages.first
      redirect_to show_products_shop_path(sid)
    end
  end

  private

  # TODO : this is fat and disgusting
  # it should be refactored entirely
  def product_params
    delocalize_config = { skus_attributes: { :price => :number,:space_length => :number, :space_width => :number, :space_height => :number, :discount => :number, :quantity => :number, :weight => :number} }

    if current_user.decorate.admin?
      params.require(:product)[:category_ids] = [params.require(:product)[:category_ids]] unless params.require(:product)[:category_ids].nil?
      shopkeeper_strong_params += [:duty_category, category_ids:[]]
    end

    params.require(:product).permit!.delocalize(delocalize_config)
  end

  def set_shop
    @shop = current_user.shop
  end

  def set_product
    @product = Product.find(params[:id])
  end

  # TODO : this protection has to be improved
  def is_admin_or_shop_order
    unless current_user.decorate.admin? || current_user.decorate.shopkeeper?
      redirect_to navigation.back(1)
    end
  end

end
