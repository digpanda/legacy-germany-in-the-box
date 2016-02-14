require 'will_paginate/array'

class ProductsController < ApplicationController

  include FunctionCache

  before_action :set_product, only: [:show, :edit, :update, :destroy]

  before_action { @show_search_area = true }

  before_action :authenticate_user!, except: [:autocomplete_product_name, :list_popular_products, :search, :show]
  acts_as_token_authentication_handler_for User, except: [:autocomplete_product_name, :list_popular_products, :search, :show]

  def autocomplete_product_name
    respond_to do |format|
      format.json {
        render :json => get_products_for_autocompletion(params[:term], params[:page] ? params[:page].to_i : 1), :status => :ok
      }
    end
  end

  def search
    founded_products = get_products_from_search_cache_for_term( params[:products_search_keyword] )

    tags_product_ids        = founded_products[:tags]
    products_product_ids    = founded_products[:products]
    categories_product_ids  = founded_products[:categories]
    brands_product_ids      = founded_products[:brands]

    @products = tags_product_ids + products_product_ids + categories_product_ids + brands_product_ids
    @products = @products.compact.uniq
    @products = @products.compact.uniq.paginate( :page => (params[:page] ? params[:page].to_i : 1), :per_page => Rails.configuration.limit_for_products_search)

    respond_to do |format|
      format.html {
        @categories_and_children, @categories_and_counters = get_category_values_for_left_menu(@products)
        render :index
      }

      format.json {
        render :search
      }
    end
  end

  def list_popular_products
    @products = Product.where(:name => '10 Blatt Seidenpapier ♥ Panda ♥').paginate(:page => (params[:page] ? params[:page].to_i : 1), :per_page => Rails.configuration.limit_for_popular_products);

    #@products = get_popular_proudcts_from_cache.paginate(:page => (params[:page] ? params[:page].to_i : 1), :per_page => Rails.configuration.limit_for_popular_products)

    respond_to do |format|
      format.html {
        @categories_and_children, @categories_and_counters = get_category_values_for_left_menu(@products)
        render :index
      }

      format.json {
        render :index
      }
    end
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    @product.owner = product_params[:owner]
    @owner = User.find(product_params[:owner])
    respond_to do |format|
      if @product.save
        @owner.saved_products << @product.id.to_str
        @owner.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end

  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  protected

    def current_top_menu_active_part
      :product
    end

  private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:network, :desc, :shopname, :prodid, :deeplink, :name, :brand, :category, :img, :imglg, :price, :priceold, :sale, :currency, :update_, :owner, :status)
    end
end






