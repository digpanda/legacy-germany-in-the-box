class Shopkeeper::ProductsController < ApplicationController

  attr_reader :shop, :products, :product

  authorize_resource :class => false

  before_action :set_shop
  before_action :set_product, except: [:index, :new, :create]
  before_action :breadcrumb_shopkeeper_products
  before_action :breadcrumb_shopkeeper_edit_product, only: [:edit]

  layout :custom_sublayout

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
=begin
      DispatchNotification.new.perform({
                                                        :user => order.user,
                                                        :title => "来因盒通知：付款成功，已通知商家准备发货 （订单号：#{order.id})",
                                                        :desc => "你好，你的订单#{order.id}已成功付款，已通知商家准备发货。若有疑问，欢迎随时联系来因盒客服：customer@germanyinthebox.com。"
                                                    })
=end
      flash[:success] = I18n.t(:update_ok, scope: :edit_product)
      redirect_to edit_shopkeeper_product_path(product)
      return
    end

    flash[:error] = product.errors.full_messages.join(', ')
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
