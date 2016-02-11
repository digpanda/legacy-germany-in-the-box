class ProductsController < ApplicationController

  include FunctionCache

  before_action :set_product, only: [:show, :edit, :update, :destroy]

  before_action { @show_search_area = true }

  before_action :authenticate_user!, except: [:autocomplete_product_name, :index, :search, :show]

  def autocomplete_product_name
    respond_to do |format|
      format.json {
        render :json => get_products_from_search_cache( params[:term] ), :status => :ok
      }
    end
  end

  def search
    founded_products = get_products_from_search_cache( params[:products_search_keyword] )
    @products = founded_products.collect{|p| Mongoid::QueryCache.cache { Product.find( p[:product_id] ) } }.compact.uniq

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

  def index
    @products = Product.where(:name => '10 Blatt Seidenpapier ♥ Panda ♥');

    #@products = get_popular_proudcts_from_cache
    @categories_and_children, @categories_and_counters = get_category_values_for_left_menu(@products)
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






