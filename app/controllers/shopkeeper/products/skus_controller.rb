class Shopkeeper::Products::SkusController < ApplicationController

  authorize_resource :class => false

  layout :custom_sublayout
  before_action :set_product
  before_action :set_sku, except: [:index, :new, :create]

  attr_reader :product, :sku, :skus

  def index
    @skus = product.skus.order_by(:c_at => :desc).paginate(:page => current_page, :per_page => 10)
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
      flash[:success] = I18n.t(:update_ok, scope: :edit_product)
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
      flash[:success] = I18n.t(:update_ok, scope: :edit_product)
      redirection_after_update
      return
    end

    flash[:error] = sku.errors.full_messages.join(', ')
    redirect_to navigation.back(1)
  end

  # TODO : this should be put into a service
  # it was imported from the old system and it's very much disgusting.
  def clone
    new_sku = sku.clone
    product.skus << new_sku
    product.save
    # source_sku = sku
    # new_sku = product.skus.build(source_sku.attributes.keep_if { |k| Sku.fields.keys.include?(k) }.except(:_id, :img0, :img1, :img2, :img3, :attach0, :data, :c_at, :u_at, :currency))
    # CopyCarrierwaveFile::CopyFileService.new(source_sku, new_sku, :img0).set_file if source_sku.img0.url
    # CopyCarrierwaveFile::CopyFileService.new(source_sku, new_sku, :img1).set_file if source_sku.img1.url
    # CopyCarrierwaveFile::CopyFileService.new(source_sku, new_sku, :img2).set_file if source_sku.img2.url
    # CopyCarrierwaveFile::CopyFileService.new(source_sku, new_sku, :img3).set_file if source_sku.img3.url
    # CopyCarrierwaveFile::CopyFileService.new(source_sku, new_sku, :attach0).set_file if source_sku.attach0.url
    # # TODO : this is buggy because of the translation system
    # # we should investigate.
    # new_sku.data = source_sku.data
    # new_sku.save
    flash[:success] = I18n.t(:clone_successful, scope: :sku)
    redirect_to navigation.back(1)
  end

  def destroy
    if sku.destroy
      flash[:success] = I18n.t(:delete_ok, scope: :edit_sku)
    else
      flash[:error] = sku.errors.full_messages.join(', ')
    end
    redirect_to navigation.back(1)
  end

  def destroy_image
    if ImageDestroyer.new(sku).perform(params[:image_field])
      flash[:success] = I18n.t(:removed_image, scope: :action)
    else
      flash[:error] = I18n.t(:no_removed_image, scope: :action)
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
