require 'will_paginate/array'

class ProductsController < ApplicationController

  SKU_IMAGE_FIELDS = [:img0, :img1, :img2, :img3]

  before_action :set_product, :set_category, :set_shop, only: [:show, :edit, :update, :destroy, :remove_sku, :remove_option, :new_sku, :show_skus, :skus]
  before_action :authenticate_user!, except: [:autocomplete_product_name, :popular, :search, :show, :skus]

  load_and_authorize_resource :class => Product

  layout :custom_sublayout, only: [:new, :new_sku, :edit, :edit_sku, :clone_sku, :show_skus]

  # conversion to new folder structure
  def show
    redirect_to guest_product_path(@product)
  end

  def new
    @shop = Shop.find(params[:shop_id])
    @product = @shop.products.build

    @customer_categories_options = DutyAndCustomerCategorySelectStore.new(Category.name)
    @duty_categories_options = DutyAndCustomerCategorySelectStore.new(DutyCategory.name)

    render :new_product
  end

  def new_sku
    @sku = @product.skus.build
  end

  def edit
    @customer_categories_options = DutyAndCustomerCategorySelectStore.new(Category.name)
    @duty_categories_options = DutyAndCustomerCategorySelectStore.new(DutyCategory.name)

    render :edit_product
  end

  def edit_sku
    @sku = @product.skus.find(params[:sku_id])
  end

  def clone_sku
    @src = @product.skus.find(params[:sku_id])
    @sku = @product.skus.build(@src.attributes.keep_if { |k| Sku.fields.keys.include?(k) }.except(:_id, :img0, :img1, :img2, :img3, :attach0, :data, :c_at, :u_at, :currency))
    CopyCarrierwaveFile::CopyFileService.new(@src, @sku, :img0).set_file if @src.img0.url
    CopyCarrierwaveFile::CopyFileService.new(@src, @sku, :img1).set_file if @src.img1.url
    CopyCarrierwaveFile::CopyFileService.new(@src, @sku, :img2).set_file if @src.img2.url
    CopyCarrierwaveFile::CopyFileService.new(@src, @sku, :img3).set_file if @src.img3.url
    CopyCarrierwaveFile::CopyFileService.new(@src, @sku, :attach0).set_file if @src.attach0.url
    @sku.data = @src.data # this is buggy because of the translation system
    @sku.save
  end

  def show_skus
  end

  def destroy_sku_image
    sku = Product.find(params[:product_id]).skus.find(params[:sku_id])
    if ImageDestroyer.new(sku, SKU_IMAGE_FIELDS).perform(params[:image_field])
      flash[:success] = "Image removed successfully"
    else
      flash[:error] = "Can't remove this image"
    end
    # TODO : this breaks because we need to refacto the system and avoid get variables like this
    # we should do this later when we refacto the whole controller - Laurent, 05/10/2016
    # redirect_to navigation.back(1)
    redirect_to edit_sku_product_path(sku.product.id, :sku_id => sku.id)
  end

  # This will display the skus for the users (logged in or not)
  def skus
  end

  def highlight
    @product = Product.find(params[:product_id])
    @product.highlight = true
    @product.save
    redirect_to navigation.back(1)
  end

  def regular
    @product = Product.find(params[:product_id])
    @product.highlight = false
    @product.save
    redirect_to navigation.back(1)
  end

  def approve
    @product = Product.find(params[:product_id])
    @product.approved = Time.now.utc
    @product.save
    redirect_to navigation.back(1)
  end

  def disapprove
    @product = Product.find(params[:product_id])
    @product.approved = nil
    @product.save
    redirect_to navigation.back(1)
  end

  def remove_sku
    @product.skus.find(params[:sku_id]).delete

    redirect_to show_skus_product_path(@product.id)
  end

  def remove_variant
    variant = @product.options.find(params[:variant_id])

    ids = variant.suboptions.map { |o| o.id.to_s }

    if @product.skus.detect { |s| s.option_ids.to_set.intersect?(ids.to_set) }
      flash[:error] = I18n.t(:sku_dependent, scope: :edit_product_variant)
    else
      if variant.delete && @product.save
        flash[:success] = I18n.t(:delete_variant_ok, scope: :edit_product_variant)
      else
        flash[:error] = variant.errors.full_messages.first
        flash[:error] ||= @product.errors.full_messages.first
      end
    end

    redirect_to edit_product_path(@product.id)
  end

  def remove_option
    if @product.skus.detect { |s| s.option_ids.to_set.include?(params[:option_id]) }
      flash[:error] = I18n.t(:sku_dependent, scope: :edit_product_variant)
    else
      variant = @product.options.find(params[:variant_id])
      option = variant.suboptions.find(params[:option_id])

      if option.delete && variant.save && @product.save
        flash[:success] = I18n.t(:delete_option_ok, scope: :edit_product_variant)
      else
        flash[:error] = option.errors.full_messages.first
        flash[:error] ||= @product.errors.full_messages.first
      end
    end

    redirect_to edit_product_path(@product.id)
  end

  def autocomplete_product_name
  end

  def search

    redirect_to(:back) and return if params["query"].nil?
    @query = params["query"]

    @products = Product.search(@query)
    @products = Product.can_buy.all

  end

  def create
    @product = Product.new(product_params)
    @product.shop = Shop.find(params[:shop_id])

      if @product.save
        flash[:success] = I18n.t(:create_ok, scope: :edit_product_new)
        redirect_to show_skus_product_path(@product.id)
      else
        flash[:error] = @product.errors.full_messages.first
        redirect_to request.referer
      end
  end

  def update

    if sku_attributes = params.require(:product)[:skus_attributes]
      sku_attributes.each do |k,v|
        v[:option_ids] = v[:option_ids].reject { |c| c.empty? }
      end
    end

    #param_options_only = {
    #  :options_attributes => recursive_hash_delete(product_params.require(:options_attributes), :suboptions_attributes) # To have mongoid to blow up by updating double attributes
    #}

    if @product.update(product_params)

      if params[:part] == :basic.to_s
        flash[:success] = I18n.t(:update_ok, scope: :edit_product)
        redirect_to show_products_shop_path(@product.shop.id)
      elsif params[:part] == :sku.to_s
        flash[:success] = I18n.t(:update_ok, scope: :edit_product_detail)
        redirect_to show_skus_product_path(@product.id)
      elsif params[:part] == :variant.to_s
        flash[:success] = I18n.t(:update_ok, scope: :edit_product_variant)
        redirect_to edit_product_path(@product.id)
      end

    else
      flash[:error] = @product.errors.full_messages.first
      redirect_to edit_product_path(@product.id)
    end
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

  def recursive_hash_delete(hash, key)
    p = proc do |_, v|
      v.delete_if(&p) if v.respond_to? :delete_if
      _ == key.to_s
    end
    hash.delete_if(&p)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def set_category
    @category = @product.categories.first
  end

  def set_shop
    @shop = @product.shop
  end

  def product_params
    delocalize_config = { skus_attributes: { :price => :number,:space_length => :number, :space_width => :number, :space_height => :number, :discount => :number, :quantity => :number, :weight => :number} }
    shopkeeper_strong_params = [:status, :desc, :name, :hs_code, :brand, :img, :data, tags:[], options_attributes: [:id, :name, suboptions_attributes: [:id, :name]], skus_attributes: [:unlimited, :id, :img0, :img1, :img2, :img3, :price, :discount, :country_of_origin, :quantity, :weight, :customizable, :status, :space_length, :space_width, :space_height, :time, :data, :attach0, option_ids: []]]

    if current_user.decorate.admin?
      params.require(:product)[:category_ids] = [params.require(:product)[:category_ids]] unless params.require(:product)[:category_ids].nil?
      shopkeeper_strong_params += [:duty_category, category_ids:[]]
    end

    params.require(:product).permit(*shopkeeper_strong_params).delocalize(delocalize_config)
  end

end
