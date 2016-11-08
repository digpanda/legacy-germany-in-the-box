class Shopkeeper::Products::SkusController < ApplicationController

  load_and_authorize_resource
  layout :custom_sublayout
  before_action :set_product

  attr_reader :product, :sku, :skus

  def index
    @skus = product.skus.order_by(:c_at => :desc).paginate(:page => current_page, :per_page => 10)
  end

  def show
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
  end

  def clone
  end

  private

  def setup_categories_options!
    @customer_categories_options = DutyAndCustomerCategorySelectStore.new(Category.name)
    @duty_categories_options = DutyAndCustomerCategorySelectStore.new(DutyCategory.name)
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def sku_params
    delocalize_config = {:price => :number,:space_length => :number, :space_width => :number, :space_height => :number, :discount => :number, :quantity => :number, :weight => :number}
    sku_params = params.require(:sku).permit!.delocalize(delocalize_config)
    # we throw away the useless option ids
    sku_params[:option_ids].reject!(&:empty?)
    sku_params
  end

end
