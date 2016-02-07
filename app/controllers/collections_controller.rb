class CollectionsController < ApplicationController

  before_action :set_collection, except: [:create_and_add,
                                          :is_product_collected,
                                          :index,
                                          :gsearch,
                                          :search_collections,
                                          :likedcolls,
                                          :new,
                                          :savedcolls,
                                          :create,
                                          :matchedcollections,
                                          :mycolls,
                                          :indexft,
                                          :userinit]

  before_action :authenticate_user!, :except => [:indexft, :show, :search_collections]

  def search_collections
    @collections = Collection.public.or({desc: /.*#{params[:collections_search_keyword]}.*/i}, {name: /.*#{params[:collections_search_keyword]}.*/i}).limit(Rails.configuration.limit_for_collections_search)

    respond_to do |format|
      format.html { render :index }
      format.json { render :search_collections }
    end
  end


  def create_and_add
    cp = collection_params
    cp[:public] = cp[:public] == '1' ? true : false;

    existing = current_user.oCollections.select { |c| c.name == cp[:name] }

    unless existing.size > 0
      c = current_user.oCollections.create!(cp)
      c.products.push(Product.find(params[:product_id]))
    else
      existing[0].products.push(Product.find(params[:product_id]))
    end

    respond_to do |format|
      format.json { render :json => { :status => :ok } }
    end
  end

  def toggle_product
    p = Product.find(params[:product_id])

    if @collection.products.include?(p)
      @collection.products.delete(p)
    else
      @collection.products.push(p)
    end

    @collection.save!

    render :json => {:status => :ok}
  end

  def is_product_collected
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
    if @collection && @collection.user == current_user
      @collection.products.delete(Product.find(params[:product_id]))

      if @collection.save
        respond_to do |format|
          format.html { redirect_to request.referer }
          format.json { render :json => {}, :status => :ok }
        end

        return
      end
    end

    respond_to do |format|
      format.json { render :json => {}, :status => :unprocessable_entity }
    end
  end

  def remove_products
    if @collection && @collection.user == current_user
      product_ids = params[:product_ids].split(',')

      product_ids.each do |product_id|
        @collection.products.delete(Product.find(product_id))
      end

      if @collection.save
        respond_to do |format|
          format.html { redirect_to request.referer }
          format.json { render :json => {}, :status => :ok }
        end

        return
      end
    end

    respond_to do |format|
      format.json { render :json => {}, :status => :unprocessable_entity }
    end
  end

  def remove_all_products
    if @collection && @collection.user == current_user
      @collection.products.each { |p| @collection.products.delete(p) }

      if @collection.save
        respond_to do |format|
          format.html { redirect_to request.referer }
          format.json { render :json => {}, :status => :ok }
        end

        return
      end
    end

    respond_to do |format|
      format.json { render :json => {}, :status => :unprocessable_entity }
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
    @user = current_user
    $i = params[:to].to_i - params[:from].to_i
    @collections = Collection.skip(params[:from].to_i).limit($i)
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
    existing = current_user.oCollections.select { |c| c.name == collection_params[:name] }

    unless existing.size > 0
      @collection = Collection.new(collection_params)
      @collection.user = current_user

      respond_to do |format|
        if @collection.save
          format.html {
            flash[:success] = 'The Collection was created successfully.'
            redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_collection )
          }

          format.json { render :show, status: :created, location: @collection }
        else
          format.html {
            flash[:error] = @collection.errors.full_messages.first
            redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_collection_new )
          }

          format.json { render json: @collection.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = 'There is another collection with the same name.'
          redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_collection_new )
        }

        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update
    existing = current_user.oCollections.select { |c| (not c.id.to_s.eql?(params[:id])) and c.name == collection_params[:name] }

    unless existing.size > 0
      respond_to do |format|
        if @collection.update(collection_params)
          format.html {
            flash[:success] = 'Updating collection is successful.'
            redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_collection)
          }

          format.json { render :show, status: :ok, location: @collection }
        else
          format.html {
            flash[:error] = @collection.errors.full_messages.first
            redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_collection_update, :collection_id => params[:id] )
          }

          format.json { render json: @collection.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = 'There is another collection with the same name.'
          redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_collection_update, :collection_id => params[:id] )
        }

        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy
    @collection.destroy
    respond_to do |format|
      format.html { redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_collection) }
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
    params.require(:collection).permit(:name, :desc, :coltype, :img, :public)
  end

end
