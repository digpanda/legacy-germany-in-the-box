require 'will_paginate/array'

class ProductsController < ApplicationController

  before_action :set_product, :set_category, :set_shop, only: [:show, :edit, :update, :destroy, :remove_sku, :remove_option, :new_sku, :show_skus, :skus]
  before_action :authenticate_user!, except: [:autocomplete_product_name, :popular, :search, :show, :skus]

  load_and_authorize_resource :class => Product

  layout :custom_sublayout, only: [:new, :new_sku, :edit, :edit_sku, :clone_sku, :show_skus]

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

  # this belong to the sku admin part and the last piece of this mess
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

  private


  def set_product
    @product = Product.find(params[:id])
  end

  def set_category
    @category = @product.categories.first
  end

  def set_shop
    @shop = @product.shop
  end

end
