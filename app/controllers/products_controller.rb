class ProductsController < ApplicationController

  before_action :set_product, only: [:show, :edit, :update, :destroy]

  before_action { @show_search_area = true }

  before_action :authenticate_user!, only: [:create, :edit, :destroy, :update]

  def autocomplete_product_name
    render :json => get_products_from_search_cache( params[:term] )
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

  def show_products_in_category
    @products = Category.find(params[:category_id]).products
    @categories_and_children, @categories_and_counters = get_category_values_for_left_menu(@products)

    respond_to do |format|
      format.html { render :index }
    end
  end

  def index
  end

  def indexr
    if(params[:num] == nil)
      @products = get_random_Product(50)
      @categories_and_children, @categories_and_counters = get_category_values_for_left_menu(@products)
  else
    @products = get_random_Product(params[:num].to_i)
    end
    @owner_name = nil
    @owner_img = nil
    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @proudct }
    end
  end

  def indexft
    $i = params[:to].to_i - params[:from].to_i
    @products = Product.limit($i).offset(params[:from].to_i)
    # @products = get_random_Product(params[:num].to_i)
    @owner_name = nil
    @owner_img = nil
    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @proudct }
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


  private
# Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end


# Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:product).permit(:network, :desc, :shopname, :prodid, :deeplink, :name, :brand, :category, :img, :imglg, :price, :priceold, :sale, :currency, :update_, :owner, :status)


  end


  def get_random_Product(n)
    i =
        cnt = Product.count
    rand = rand(cnt+1)
    # just to test 
    products = Product.where(:name => '10 Blatt Seidenpapier ♥ Panda ♥');
    #products  += Product.skip(rand).limit(n)

    #while i < n-2  do
    # products.push(Product.skip(rand).limit(1))
    # rand = rand(cnt+1)
    # i +=1
    # end
    products


  end

  def get_category_values_for_left_menu(products)
    categories_and_children = {}
    categories_and_counters = {}

    products.each do |p|
      p.categories.each do |c|
        if not categories_and_children.has_key?(c.parent)
          categories_and_children[c.parent] = []
          categories_and_counters[c] = 0
          categories_and_counters[c.parent] = 0
        end

        categories_and_children[c.parent] << c if not categories_and_children[c.parent].include?(c)
        categories_and_counters[c] += 1
        categories_and_counters[c.parent] += 1
      end
    end

    return categories_and_children, categories_and_counters
  end

  protected

  def current_top_menu_active_part
    :product
  end

end






