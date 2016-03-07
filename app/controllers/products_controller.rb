require 'will_paginate/array'

class ProductsController < ApplicationController

  include FunctionCache

  before_action :set_product, only: [:show, :edit, :update, :destroy, :get_sku_for_options, :remove_sku, :remove_option]

  before_action { @show_search_area = true }

  before_action :authenticate_user!, except: [:autocomplete_product_name, :list_popular_products, :search, :show, :get_sku_for_options]

  load_and_authorize_resource

  def like_product
    current_user.dCollection = Collection.create( :name => :default, :user => current_user ) unless current_user.dCollection
    current_user.dCollection.products.push(@product) unless current_user.dCollection.products.find(@product)

    if current_user.dCollection.save
      respond_to do |format|
        format.html { redirect_to request.referer }
        format.json { render :json => { :status => :ok, :collection_id => current_user.dCollection.id }, :status => :ok }
      end

      return
    end

    respond_to do |format|
      format.json { render :json => { :status => :lo }, :status => :unprocessable_entity }
    end
  end

  def dislike_product
    current_user.dCollection = Collection.create( :name => :default, :user => current_user ) unless current_user.dCollection
    current_user.dCollection.products.delete(@product)

    if current_user.dCollection.save
      respond_to do |format|
        format.html { redirect_to request.referer }
        format.json { render :json => { :status => :ok, :collection_id => current_user.dCollection.id }, :status => :ok }
      end

      return
    end

    respond_to do |format|
      format.json { render :json => { :status => :ko  }, :status => :unprocessable_entity }
    end
  end

  def remove_sku
    @product.skus.find(params[:sku_id]).delete
    redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_product_detail, :product_id => @product.id)
  end

  def remove_variant
    variant = @product.options.find(params[:variant_id])

    ids = variant.suboptions.map { |o| o.id.to_s }

    if @product.skus.detect { |s| s.option_ids.to_set.intersect?(ids.to_set) }
      flash[:error] = I18n.t(:sku_dependent, scope: :edit_product_variant)
    else
      if variant.delete
        flash[:success] = I18n.t(:delete_variant_ok, scope: :edit_product_variant)
      else
        flash[:error] = variant.errors.full_messages.first
      end
    end

    redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_product_variant, :product_id => @product.id)
  end

  def remove_option
    if @product.skus.detect { |s| s.option_ids.to_set.include?(params[:option_id]) }
      flash[:error] = I18n.t(:sku_dependent, scope: :edit_product_variant)
    else
      variant = @product.options.find(params[:variant_id])
      option = variant.suboptions.find(params[:option_id])

      if option.delete
        flash[:success] = I18n.t(:delete_option_ok, scope: :edit_product_variant)
      else
        flash[:error] = option.errors.full_messages.first
      end
    end

    redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_product_variant, :product_id => @product.id)
  end

  def get_sku_for_options
    skus = @product.skus

    skus.each do |s|
      if s.option_ids.to_set == params[:option_ids].to_set
        respond_to do |format|
          format.json {
            @sku = s
            render :show_sku, locals: { sku: s }, :status => :ok
          }
        end

        return
      end
    end

    respond_to do |format|
      format.json {
        render :json => {}, :status => :not_found
      }
    end
  end

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
    @products = Product.is_active.where(:name => /.*10 Blatt Seidenpapier ♥ Panda ♥.*/i).paginate(:page => (params[:page] ? params[:page].to_i : 1), :per_page => Rails.configuration.limit_for_popular_products);

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

  def create
    @product = Product.new(product_params)
    @product.shop = current_user.shop

    respond_to do |format|
      @product.categories = params.require(:product)[:categories].map { |cid| Category.find(cid) if not cid.blank? }.compact

      if @product.save
        format.html {
          flash[:success] = I18n.t(:create_ok, scope: :edit_product_new)
          redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_product_update, :product_id => @product.id )
        }

        format.json { render json: { status: :ok, product_id: @product.id }, status: :ok }
      else
        format.html {
          flash[:error] = @product.errors.full_messages.first
          redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_product_new )
        }

        format.json { render json: { status: :ko }, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if params.require(:product)[:categories]
        @product.categories.clear
        @product.categories << params.require(:product)[:categories].map { |cid| Category.find(cid) if not cid.blank? }.compact
      end

      if @product.update(product_params)
        format.html {
          if params[:part] == :basic.to_s
            Rails.cache.clear

            flash[:success] = I18n.t(:update_ok, scope: :edit_product)
            redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_product)
          elsif params[:part] == :sku.to_s
            flash[:success] = I18n.t(:update_ok, scope: :edit_product_detail)
            redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_product_detail, :product_id => @product.id)
          elsif params[:part] == :variant.to_s
            flash[:success] = I18n.t(:update_ok, scope: :edit_product_variant)
            redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_product_variant, :product_id => @product.id)
          end
        }

        format.json { render :show, status: :ok, location: @product }
      else

        format.html {
          flash[:error] = @product.errors.full_messages.first
          redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_product_update, :product_id => @product.id )
        }
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
      params.require(:product).permit(:desc, :name, :brand, :img, tags:[], options_attributes: [:id, :name, suboptions_attributes: [:id, :name]], skus_attributes: [:id, :img0, :img1, :img2, :img3, :price, :quantity, :currency, :weight, :customizable, :status, option_ids: []])
    end
end






