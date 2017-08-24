class Shopkeeper::Products::SkusController < ApplicationController
  include DestroyImage

  attr_reader :product, :sku, :skus

  authorize_resource class: false

  layout :custom_sublayout
  before_action :set_product
  before_action :set_sku, except: [:index, :new, :create]
  before_action :breadcrumb_shopkeeper_products, :breadcrumb_shopkeeper_edit_product, :breadcrumb_shopkeeper_product_skus
  before_action :breadcrumb_shopkeeper_product_edit_sku, only: [:edit]

  def index
    @skus = product.skus.order_by(c_at: :desc).paginate(page: current_page, per_page: 10)
  end

  def new
    @sku = Sku.new
    sku.product = product
  end

  # the sku create is actually an update of the product itself
  # because it's an embedded document.
  def create
    @sku = Sku.new(sku_params)
    sku.product = product

    if sku.save && product.save
      flash[:success] = I18n.t('edit_product.update_ok')
      redirection_after_update
      return
    end

    flash[:error] = sku.errors.full_messages.join(', ')
    redirect_to navigation.back(1)
  end

  def edit
  end

  def update
    if sku.update(sku_params)
      flash[:success] = I18n.t('edit_product.update_ok')
      redirection_after_update
      return
    end

    flash[:error] = sku.errors.full_messages.join(', ')
    redirect_to navigation.back(1)
  end

  def clone
    if SkuCloner.new(product, sku).process.success?
      flash[:success] = I18n.t('sku.clone_successful')
    else
      flash[:error] = 'Could not clone the sku.'
    end

    redirection_after_update
  end

  def destroy
    if sku.destroy
      flash[:success] = I18n.t('edit_sku.delete_ok')
    else
      flash[:error] = sku.errors.full_messages.join(', ')
    end
    redirect_to navigation.back(1)
  end

  private

    def redirection_after_update
      redirect_to shopkeeper_product_skus_path(product)
    end

    def set_product
      @product = Product.find(params[:product_id])
    end

    def set_sku
      @sku = product.skus.find(params[:sku_id] || params[:id])
    end

    def sku_params
      params.require(:sku).permit!.tap do |sku_params|
        # we throw away the useless option ids
        sku_params[:option_ids].reject!(&:empty?)
      end
    end
end
