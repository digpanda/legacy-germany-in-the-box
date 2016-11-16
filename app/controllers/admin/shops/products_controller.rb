class Admin::Shops::ProductsController < ApplicationController

  authorize_resource :class => false

  before_action :set_shop
  before_action :set_categories_options, only: [:new, :edit]
  before_action :set_product, except: [:index, :new, :create]

  layout :custom_sublayout

  attr_reader :shop, :products, :product

  def index
    @products = shop.products.order_by(:c_at => :desc).paginate(:page => current_page, :per_page => 10)
  end

  def new
    @product = shop.products.build
  end

  def create
    @product = shop.products.build(product_params)

    if product.save
      flash[:success] = I18n.t(:update_ok, scope: :edit_product)
    else
      flash[:error] = product.errors.full_messages.join(', ')
    end
    redirect_to navigation.back(1)
  end

  def edit
  end

  def update
    if product.update(product_params)
      flash[:success] = I18n.t(:update_ok, scope: :edit_product)
    else
      flash[:error] = product.errors.full_messages.join(', ')
    end
    redirect_to navigation.back(1)
  end

  def destroy
    if product.destroy
      flash[:success] = I18n.t(:delete_ok, scope: :edit_product)
    else
      flash[:error] = product.errors.full_messages.join(', ')
    end
    redirect_to navigation.back(1)
  end

  def highlight
    product.highlight = true
    product.save
    redirect_to navigation.back(1)
  end

  def regular
    product.highlight = false
    product.save
    redirect_to navigation.back(1)
  end

  def approve
    product.approved = Time.now.utc
    product.save
    redirect_to navigation.back(1)
  end

  def disapprove
    product.approved = nil
    product.save
    redirect_to navigation.back(1)
  end

  private

  # this is to setup the listing of the customer categories and duty categories
  # when creating / editing a product
  def set_categories_options
    @customer_categories_options = DutyAndCustomerCategorySelectStore.new(Category.name)
    @duty_categories_options = DutyAndCustomerCategorySelectStore.new(DutyCategory.name)
  end

  def product_params
    params.require(:product).permit!
  end

  def set_shop
    @shop = Shop.find(params[:shop_id] || params[:id])
  end

  def set_product
    @product = Product.find(params[:product_id] || params[:id])
  end

end
