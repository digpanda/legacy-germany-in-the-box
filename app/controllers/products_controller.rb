require 'will_paginate/array'

class ProductsController < ApplicationController

  before_action :set_product, :set_category, :set_shop, only: [:show, :edit, :update, :destroy, :remove_sku, :remove_option, :new_sku, :show_skus, :skus]
  before_action :authenticate_user!, except: [:autocomplete_product_name, :popular, :search, :show, :skus]

  load_and_authorize_resource :class => Product

  layout :custom_sublayout, only: [:new, :new_sku, :edit, :edit_sku, :clone_sku, :show_skus]

  # TODO : this belong to the sku admin part and the last piece of this mess
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
