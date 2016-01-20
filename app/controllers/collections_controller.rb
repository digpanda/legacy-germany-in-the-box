class CollectionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_collection, except: [:create_and_add_to_collection, :is_product_in_user_collections, :remove_product, :toggle_product, :index, :gsearch, :colsearch, :likedcolls, :new, :savedcolls, :create, :matchedcollections, :mycolls, :indexft, :userinit]

  before_action :authenticate_user!, :except => [:add_product]

  def create_and_add_to_collection
    params = collection_params
    params[:public] = params[:public] == '1' ? true : false;
    current_user.oCollections.create!(params)

    respond_to do |format|
      format.json { render :json => { :status => :ok } }
    end
  end

  def toggle_product
    c = Collection.find(params[:collection_id])
    p = Product.find(params[:product_id])

    if c.products.include?(p)
      c.products.delete(p)
    else
      c.products.push(p)
    end

    c.save!

    render :json => {:status => :ok}
  end

  def is_product_in_user_collections
    p = Product.find(params[:product_id])

    current_user.oCollections.each do |c|
      if c.products.include?(p)
        respond_to do |format|
          format.json { render :json => { :contained => 'true' } }
        end

        return
      end
    end

    respond_to do |format|
      format.json { render :json => { :contained => 'false' } }
    end
  end

  def remove_product
    c = Collection.find(params[:collection_id])
    c.products.delete(Product.find(params[:product_id]))
    c.save!

    respond_to do |format|
      format.html { redirect_to request.referer }
      format.json { render :json => {:status => :ok} }
    end
  end

  def gsearch
    @user = User.find('55bb6c3a69702d64d700000b')

    if params[:search_topic] == "1"
      @chats = Chats.all
      respond_to do |format|
        format.html { render :template => "chats/index" }
        format.json { render :index, status: :ok, location: @chats }
      end
    elsif params[:search_topic] == "2"
      @products = Product.or({brand: /.*#{params[:q]}.*/i}, {name: /.*#{params[:q]}.*/i}, {category: /.*#{params[:q]}.*/i}).limit(50)
      respond_to do |format|
        format.html { render :template => "products/index" }
        format.json { render :index, status: :ok, location: @products }
      end
    elsif params[:search_topic] == "3"
      @collections = Collection.or({desc: /.*#{params[:q]}.*/i}, {name: /.*#{params[:q]}.*/i}).limit(50)
      respond_to do |format|
        format.html { render :index }
        format.json { render :index, status: :ok, location: @collections }
      end
    end
  end


  # GET /collections
  # GET /collections.json
  def index
    @user = User.find('55bb6c3a69702d64d700000b')
    @collections = Collection.all
  end

  def indexft

    @user = User.find('55bb6c3a69702d64d700000b')
    $i = params[:to].to_i - params[:from].to_i
    @collections = Collection.skip(params[:from].to_i).limit($i)
    @products = Product.skip(30).limit(10)
    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @collection }
    end
  end


  # GET /collections/1
  # GET /collections/1.json
  def show
    @products = []
    @collection.products.each do |i|
      @product = Product.find (i)
      @products << @product
    end

  end

  # GET /collections/new
  def new
    @collection = Collection.new
  end

  # GET /collections/1/edit
  def edit
  end

  # POST /collections
  # POST /collections.json


  def create

    @collection = Collection.new(collection_params)
    @collection.user = User.find(params[:owner_id])
    respond_to do |format|
      if @collection.save
        @owner.saved_collections << @collection.id.to_str
        @owner.save
        format.html { redirect_to @collection, notice: 'Collection was successfully created.' }
        format.json { render :show, status: :created, location: @collection }
      else
        format.html { render :new }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update
    respond_to do |format|
      if @collection.update(collection_params)
        format.html { redirect_to @collection, notice: 'Collection was successfully updated.' }
        format.json { render :show, status: :ok, location: @collection }
      else
        format.html { render :edit }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy
    @collection.destroy
    respond_to do |format|
      format.html { redirect_to collections_url, notice: 'Collection was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def mycolls
    @collections = Collection.where owner: params[:owner_id]
    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @collection }
    end
  end


  def savedcolls
    @collections = []
    @user = User.find(params[:owner_id])
    @user.saved_collections.each do |i|
      @collection = Collection.find (i)
      @collections << @collection
    end
    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @collection }
    end

  end

  def likedcolls
    @collections = []
    @user = User.find(params[:owner_id])
    @user.liked_collections.each do |i|
      @collection = Collection.find (i)
      @collections << @collection
    end
    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @collection }
    end
  end


  def getinfo
    @products = []
    @owner = User.find(@collection.owner)
    @powner = []
    @collection.products.each do |i|
      @product = Product.find(i)
      @products << @product

    end
    respond_to do |format|
      format.html { render :show }
      format.json { render :show, status: :ok, location: @collection }
    end
  end

  def matchedcollections
    @collections = []
    @acollections = Collection.all
    @acollections.each do |collection|
      if collection.products.include?(params[:id])
        @collections << collection
      end
    end
    @collections = @collections.take(params[:num].to_i)

    respond_to do |format|
      format.json { render :index, status: :ok, location: @collection }
    end
  end


  def colsearch
    if (params[:folds] == "0")
      @collections = Collection.or({desc: /.*#{params[:keyword]}.*/i}, {name: /.*#{params[:keyword]}.*/i}).limit(50)
    else
      @i = params[:folds].to_i
      @collections = Collection.or({brand: /.*#{params[:keyword]}.*/i}, {name: /.*#{params[:keyword]}.*/i}).skip(@i*50).limit(50)
      # @products = Product.search(params[:keyword]).order("created_at DESC")
    end
    # @products << Product.where(name: params[:keyword])
    # @products << Product.where(category: params[:keyword])

    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @collection }
    end

  end

  def similarcoli
    @collections = Collection.all.where(coltype: @collection.coltype).take(params[:num].to_i)
    respond_to do |format|
      format.json { render :index, status: :ok, location: @collection }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_collection
    @collection = Collection.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def collection_params
    params.require(:collection).permit(:name, :desc, :visible, :coltype, :img, :public)
  end

end
