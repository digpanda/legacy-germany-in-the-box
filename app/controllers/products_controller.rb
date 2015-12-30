class ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_product, only: [:show, :edit, :update, :destroy, :similarproductsi]
  before_action { @show_search_area = true }

  def autocomplete_product_name
    render :json => get_products_from_search_cache( params[:term] )
  end

  def search_products
    products = get_products_from_search_cache( params[:product_search_area] )
    @products = products.collect{|p| p.obj}
    respond_to do |format|
      format.html { render :index }
    end
  end

# time = Time.new
# GET /products
# GET /products.json
  def index
  end

  def showindex
    @collection = Collection.find(params[:col_id])
    @products = []
    @collection.products.each do |i|
      @product = Product.find (i)

      @products << @product
    end
    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @proudct }
    end

  end


  def indexr
    if(params[:num] == nil)
      @products = get_random_Product(50)


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

# GET /products/1
# GET /products/1.json


  def prodsearch
    if (params[:folds] == "0")
      @products = Product.or({brand: /.*#{params[:keyword]}.*/i}, {name: /.*#{params[:keyword]}.*/i}, {category: /.*#{params[:keyword]}.*/i}).limit(50)
    else
      @i = params[:folds].to_i
      @products = Product.or({brand: /.*#{params[:keyword]}.*/i}, {name: /.*#{params[:keyword]}.*/i}, {category: /.*#{params[:keyword]}.*/i}).skip(@i*50).limit(50)
      # @products = Product.search(params[:keyword]).order("created_at DESC")
    end
    # @products << Product.where(name: params[:keyword])
    # @products << Product.where(category: params[:keyword])

    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @proudct }
    end

  end


  def prodsearchbrand
    if (params[:folds] == "0")
      @products = Product.or({brand: params[:keyword]}).limit(50)
    else
      @i = params[:folds].to_i
      @products = Product.or({brand: params[:keyword]}).skip(@i*50).limit(50)
      # @products = Product.search(params[:keyword]).order("created_at DESC")
    end
    # @products << Product.where(name: params[:keyword])
    # @products << Product.where(category: params[:keyword])

    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @proudct }
    end

  end


  def prodsearchcat
    if (params[:folds] == "0")
      @products = Product.or({category: /.*#{params[:keyword]}.*/i}).limit(50)
    else
      @i = params[:folds].to_i
      @products = Product.or({category: /.*#{params[:keyword]}.*/i}).skip(@i*50).limit(50)
      # @products = Product.search(params[:keyword]).order("created_at DESC")
    end
    # @products << Product.where(name: params[:keyword])
    # @products << Product.where(category: params[:keyword])

    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @proudct }
    end

  end


  def show
    #  name = @product.ProductName
    #  File.open('product.log', 'a') do |f2|
    # # use "\n" for two lines of text
    #  f2.write Time.new
    #  f2.write "==>"
    #  f2.write name
    #  f2.write "  showed"
    #  f2.write "\n"

    # end

    begin
      @user = User.find(@product.owner)
      @owner_name = @user.username
      @owner_img = @user.pic
    rescue Mongoid::Errors::InvalidFind
      @owner_name = nil
      @owner_img = nil
    end

  end

# GET /products/new
  def new
    @product = Product.new
  end

# GET /products/1/edit
  def edit
  end

# POST /products
# POST /products.json
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
#     name = @product.ProductName
# File.open('product.log', 'a') do |f2|  
#   # use "\n" for two lines of text  
#   f2.write Time.new
#   f2.write "==>"
#   f2.write name
#   f2.write "  created"
#   f2.write "\n"
#   end

  end

# PATCH/PUT /products/1
# PATCH/PUT /products/1.json
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

# DELETE /products/1
# DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
    #   name = @product.ProductName
    # File.open('product.log', 'a') do |f2|
    # # use "\n" for two lines of text
    # f2.write Time.new
    # f2.write "==>"
    # f2.write name
    # f2.write "  deleted"
    # f2.write "\n"
    # end

  end


  def similarproductsi
    @products = Product.all.where(category: @product.category).take(params[:num].to_i)
    respond_to do |format|
      format.json { render :index, status: :ok, location: @proudct }
    end
  end

  def savedprods
    @products = []
    @user = User.find(params[:owner_id])
    @user.saved_products.each do |i|
      @product = Product.find (i)
      @products << @product
    end
    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @proudct }
    end

  end


  def search
    if (params[:folds] == "0")
      @users = User.or({username: /.*#{params[:keyword]}.*/i}, {fname: /.*#{params[:keyword]}.*/i}, {email: /.*#{params[:keyword]}.*/i}).limit(50)
      @products = Product.or({brand: /.*#{params[:keyword]}.*/i}, {name: /.*#{params[:keyword]}.*/i}, {category: /.*#{params[:keyword]}.*/i}).limit(50)
      @collections = Collection.or({desc: /.*#{params[:keyword]}.*/i}, {name: /.*#{params[:keyword]}.*/i}).limit(50)
    else
      @i = params[:folds].to_i
      @collections = Collection.or({brand: /.*#{params[:keyword]}.*/i}, {name: /.*#{params[:keyword]}.*/i}).skip(@i*50).limit(50)
      @users = User.or({username: /.*#{params[:keyword]}.*/i}, {fname: /.*#{params[:keyword]}.*/i}, {email: /.*#{params[:keyword]}.*/i}).skip(@i*50).limit(50)
      @products = Product.or({brand: /.*#{params[:keyword]}.*/i}, {name: /.*#{params[:keyword]}.*/i}, {category: /.*#{params[:keyword]}.*/i}).skip(@i*50).limit(50)

    end


    respond_to do |format|
      format.html { render :search }
      format.json { render :search, status: :ok, location: @proudct }
    end

  end


  def getpostedprods
    @products = Product.where(owner: params[:owner_id])

    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @proudct }
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

  def get_products_from_search_cache(term)
    Rails.cache.fetch("products_search_cache_#{term}", :expires_in => Rails.configuration.product_search_cache_expire_limit ) {
      products_from_products = sort_and_map_products(Product.where({ name: /.*#{term}.*/i }), :product)
      products_from_brands = sort_and_map_products(Product.where({ brand: /.*#{term}.*/i }), :brand)

      products_from_categories =  []

      Category.where( { name: /.*#{term}.*/i } ).to_a.each do |c|
        products_from_categories |=  sort_and_map_products(c.products, :category)
      end

      products_from_products + products_from_brands + products_from_categories
    }
  end

  def sort_and_map_products(products, search_category)
    products.sort! { |a,b| a.name.downcase <=> b.name.downcase }.map { |p| {:label => p.name, :value => p.name, :sc => search_category, :obj => p } }
  end

  protected

  def current_top_menu_active_part
    :product
  end

end






