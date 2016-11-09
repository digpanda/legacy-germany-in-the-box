class Shopkeeper::Products::SkusController < ApplicationController

  SKU_IMAGE_FIELDS = [:img0, :img1, :img2, :img3]

  # load_and_authorize_resource <-- freaking buggy
  layout :custom_sublayout
  before_action :set_product
  before_action :set_sku, except: [:index, :new]

  attr_reader :product, :sku, :skus

  def index
    @skus = product.skus.order_by(:c_at => :desc).paginate(:page => current_page, :per_page => 10)
  end

  def new
    setup_categories_options!
    @sku = Sku.new
  end

  # the sku create is actually an update of the product itself
  # because it's an embedded document.
  def create

    @sku = Sku.new(sku_params)
    @sku.product = product

    if sku.save && product.save
      flash[:success] = I18n.t(:update_ok, scope: :edit_product)
      redirect_to shopkeeper_product_skus_path(product)
      return
    end

    flash[:error] = sku.errors.full_messages.join(', ')
    redirect_to navigation.back(1)

  end

  def edit
  end

  def update
    if sku.update(sku_params)
      flash[:success] = I18n.t(:update_ok, scope: :edit_product)
      redirect_to shopkeeper_product_skus_path
      return
    end
    flash[:error] = sku.errors.full_messages.join(', ')
    redirect_to navigation.back(1)
  end

  def clone
  end

  def destroy
    if sku.destroy
      flash[:success] = I18n.t(:delete_ok, scope: :edit_sku)
      redirect_to navigation.back(1)
      return
    end
    flash[:error] = sku.errors.full_messages.join(', ')
    redirect_to navigation.back(1)
  end

  def destroy_image
    if ImageDestroyer.new(sku, SKU_IMAGE_FIELDS).perform(params[:image_field])
      flash[:success] = "Image removed successfully"
      redirect_to navigation.back(1)
      return
    end
    flash[:error] = "Can't remove this image"
    redirect_to navigation.back(1)
  end

  private

  def setup_categories_options!
    @customer_categories_options = DutyAndCustomerCategorySelectStore.new(Category.name)
    @duty_categories_options = DutyAndCustomerCategorySelectStore.new(DutyCategory.name)
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_sku
    @sku = product.skus.find(params[:id] || params[:sku_id])
  end

  def sku_params
    delocalize_config = {:price => :number,:space_length => :number, :space_width => :number, :space_height => :number, :discount => :number, :quantity => :number, :weight => :number}
    sku_params = params.require(:sku).permit!.delocalize(delocalize_config)
    # we throw away the useless option ids
    sku_params[:option_ids].reject!(&:empty?)
    sku_params
  end

end
