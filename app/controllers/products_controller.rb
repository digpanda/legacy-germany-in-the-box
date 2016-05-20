require 'will_paginate/array'

class ProductsController < ApplicationController

  include AppCache

  before_action :set_product, only: [:show, :edit, :update, :destroy, :get_sku_for_options, :remove_sku, :remove_option, :new_sku, :show_skus, :skus]

  before_action :authenticate_user!, except: [:autocomplete_product_name, :popular, :search, :show, :get_sku_for_options, :skus]

  load_and_authorize_resource

  layout :custom_sublayout, only: [:new, :new_sku, :edit, :edit_sku, :clone_sku, :show_skus]

  def new
    @shop = Shop.find(params[:shop_id])
    @product = @shop.products.build

    @customer_categories_options = DutyAndCustomerCategorySelectStore.new(Category.name)
    @duty_categories_options = DutyAndCustomerCategorySelectStore.new(DutyCategory.name)

    render :new_product
  end

  def new_sku
    @sku = @product.skus.build

    render :new_sku
  end

  def edit
    @customer_categories_options = DutyAndCustomerCategorySelectStore.new(Category.name)
    @duty_categories_options = DutyAndCustomerCategorySelectStore.new(DutyCategory.name)

    render :edit_product
  end

  def edit_sku
    @sku = @product.skus.find(params[:sku_id])
    render :edit_sku
  end

  def clone_sku
    @src = @product.skus.find(params[:sku_id])
    @sku = @product.skus.build(@src.attributes.except(:_id, :img0, :img1, :img2, :img3))
    CopyCarrierwaveFile::CopyFileService.new(@src, @sku, :img0).set_file if @src.img0.url
    CopyCarrierwaveFile::CopyFileService.new(@src, @sku, :img1).set_file if @src.img1.url
    CopyCarrierwaveFile::CopyFileService.new(@src, @sku, :img2).set_file if @src.img2.url
    CopyCarrierwaveFile::CopyFileService.new(@src, @sku, :img3).set_file if @src.img3.url
    @sku.save

    render :clone_sku
  end

  def show_skus 
    render :show_skus
  end

  # This will display the skus for the users (logged in or not)
  def skus
    respond_to do |format|
      format.json { render :skus}
    end
  end

  def like

    @product = Product.find(params[:id])
    @favorites =  current_user.favorites
    @favorites << @product

=begin
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
=end

  end

  def unlike

    @product = Product.find(params[:id])
    @favorites = current_user.favorites
    @favorites.delete(@product)

=begin
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
=end
  end

  def remove_sku
    @product.skus.find(params[:sku_id]).delete

    redirect_to show_skus_product_path(@product.id, :user_info_edit_part => :edit_product_detail)
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

    redirect_to edit_product_path(@product.id, :user_info_edit_part => :edit_product_update)
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

    redirect_to edit_product_path(@product.id, :user_info_edit_part => :edit_product_update)
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
        render :json => AppCache.get_products_for_autocompletion(params[:term], params[:pages] ? params[:pages].to_i : 1), :status => :ok
      }
    end
  end

  def search

    redirect_to(:back) and return if params["query"].nil?
    @query = params["query"]

    @products = Product.search(@query)

=begin
    founded_products = AppCache.get_products_from_search_cache_for_term( params[:products_search_keyword] )

    tags_product_ids        = founded_products[:tags]
    products_product_ids    = founded_products[:products]
    categories_product_ids  = founded_products[:categories]
    brands_product_ids      = founded_products[:brands]

    @products = tags_product_ids + products_product_ids + categories_product_ids + brands_product_ids
    @products = @products.compact.uniq
    @products = @products.compact.uniq.paginate( :pages => (params[:pages] ? params[:pages].to_i : 1), :per_page => Rails.configuration.limit_for_products_search)

    respond_to do |format|
      format.html {
        @categories_and_children, @categories_and_counters = AppCache.get_category_values_for_left_menu(@products)
        render :index
      }

      format.json {
        render :search
      }
    end
=end

  end

  def popular

    @products = Product.buyable.paginate(:pages => (params[:pages] ? params[:pages].to_i : 1), :per_page => Rails.configuration.limit_for_popular_products);
    @show_search_area = true

    respond_to do |format|
      
      format.html {
        @categories_and_children, @categories_and_counters = AppCache.get_category_values_for_left_menu(@products)
        render :index
      }

      format.json {
        render :popular
      }
    end

  end

  def show

    @product = Product.find(params[:id])
    
    respond_to do |format|
      format.json {
        
      }
      format.html {

      }
    end

  end

  def create
    @product = Product.new(product_params)
    @product.shop = Shop.find(params[:shop_id])

    respond_to do |format|
      if @product.save
        format.html {
          flash[:success] = I18n.t(:create_ok, scope: :edit_product_new)
          redirect_to show_skus_product_path(@product.id, :user_info_edit_part => :edit_product)
        }
      else
        format.html {
          flash[:error] = @product.errors.full_messages.first
          redirect_to request.referer
        }
      end
    end
  end

  def update
    respond_to do |format|
      if sku_attributes = params.require(:product)[:skus_attributes]
        sku_attributes.each do |k,v|
          v[:option_ids] = v[:option_ids].reject { |c| c.empty? }
        end
      end

      if @product.update(product_params)
        format.html {
          if params[:part] == :basic.to_s
            flash[:success] = I18n.t(:update_ok, scope: :edit_product)
            redirect_to show_products_shop_path(@product.shop.id, :user_info_edit_part => :edit_product)
          elsif params[:part] == :sku.to_s
            flash[:success] = I18n.t(:update_ok, scope: :edit_product_detail)
            redirect_to show_skus_product_path(@product.id, :user_info_edit_part => :edit_product_detail)
          elsif params[:part] == :variant.to_s
            flash[:success] = I18n.t(:update_ok, scope: :edit_product_variant)
            redirect_to edit_product_path(@product.id, :user_info_edit_part => :edit_product_variant)
          end
        }
      else
        format.html {
          flash[:error] = @product.errors.full_messages.first
          redirect_to edit_product_path(@product.id, :user_info_edit_part => :edit_product_update)
        }
      end
    end
  end

  def destroy
    sid = @product.shop.id
    respond_to do |format|
      if @product.destroy
        format.html {
          flash[:success] = I18n.t(:delete_ok, scope: :edit_product)
          redirect_to show_products_shop_path(sid, :user_info_edit_part => :edit_product)
        }
      else
        format.html {
          flash[:error] = @product.errors.full_messages.first
          redirect_to show_products_shop_path(sid, :user_info_edit_part => :edit_product)
        }
      end
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
      delocalize_config = { skus_attributes: { :price => :number,:space_length => :number, :space_width => :number, :space_height => :number, :discount => :number, :quantity => :number, :weight => :number} }
      params.require(:product)[:category_ids]&.delete('')
      params.require(:product).permit(:desc, :name, :brand, :img, :duty_category, :data, category_ids:[], tags:[], options_attributes: [:id, :name, suboptions_attributes: [:id, :name]], skus_attributes: [:id, :img0, :img1, :img2, :img3, :price, :discount, :quantity, :weight, :customizable, :status, :unit, :space_length, :space_width, :space_height, :time, :data, :attach0, option_ids: []]).delocalize(delocalize_config)
    end
end






