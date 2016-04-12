class CollectionsController < ApplicationController

  before_action :set_collection, except: [:create_and_add,
                                          :is_collected,
                                          :index,
                                          :search,
                                          :show_liked_by_me,
                                          :show_my_collections,
                                          :new,
                                          :create,
                                          :show_user_collections]

  before_action :authenticate_user!, :except => [:search, :index, :show, :show_user_collections]

  load_and_authorize_resource

  def show_collections
    render "show_#{current_user.role.to_s}_collections", layout: "#{current_user.role.to_s}_sublayout"
  end

  def search
    @collections = Collection.is_active.is_public.or({desc: /.*#{params[:keyword]}.*/i}, {name: /.*#{params[:keyword]}.*/i}).limit(Rails.configuration.limit_for_collections_search)

    respond_to do |format|
      format.html { render :index }
      format.json { render :search }
    end
  end


  def create_and_add
    cp = collection_params
    cp[:public] = cp[:public] == 'true' ? true : false;

    existing = current_user.oCollections.select { |c| c.name == cp[:name] }

    unless existing.size > 0
      c = current_user.oCollections.create!(cp)
      c.products.push(Product.find(params[:product_id]))
    else
      existing[0].products.push(Product.find(params[:product_id]))
    end

    respond_to do |format|
      format.json { render :json => { :status => :ok }, :status => :ok }
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

    render :json => {:status => :ok}, :status => :ok
  end

  def is_collected
    p = Product.find(params[:product_id])

    current_user.oCollections.each do |c|
      if c.products.include?(p)
        respond_to do |format|
          format.json { render :json => { :contained => 'true' }, :status => :ok }
        end

        return
      end
    end

    respond_to do |format|
      format.json { render :json => { :contained => 'false' }, :status => :ok }
    end
  end

  def add_product
    if @collection && @collection.user == current_user
      @collection.products.push(Product.find(params[:product_id]))

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

  def add_products
    if @collection && @collection.user == current_user
      product_ids = params[:product_ids].split(',')

      product_ids.each do |product_id|
        @collection.products.push(Product.find(product_id))
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

  def index
    @collections = Collection.public
    respond_to do |format|
      format.html { render :index }
      format.json { render :index, :status => :ok }
    end
  end

  def show
    if @collection && @collection.public
      respond_to do |format|
        format.html { render :show }
        format.json { render :show, :status => :ok }
      end
    else
      respond_to do |format|
        format.html { render :show }
        format.json { render json: { status: :ko }, status: :unprocessable_entity }
      end
    end
  end

  def show_user_collections
    @collections = Collection.public.where( :user_id => params[:user_id] )

    respond_to do |format|
      format.json { render :index }
    end
  end

  def new
    @collection = Collection.new
    render "new_#{current_user.role.to_s}_collection", layout: "#{current_user.role.to_s}_sublayout"
  end

  def edit
    render "edit_#{current_user.role.to_s}_collection", layout: "#{current_user.role.to_s}_sublayout"
  end

  def create
    existing = current_user.oCollections.where( :name => collection_params[:name] )

    unless existing.size > 0
      @collection = Collection.new(collection_params)
      @collection.user = current_user

      respond_to do |format|
        if @collection.save
          format.html {
            flash[:success] = I18n.t(:create_ok, scope: :edit_collection_new)
            redirect_to show_collections_user_path(current_user, :user_info_edit_part => :edit_collection )
          }

          format.json { render json: { status: :ok, collection_id: @collection.id }, status: :ok }
        else
          format.html {
            flash[:error] = I18n.t(:create_ko, scope: :edit_collection_new)
            redirect_to new_collection_user_path(current_user, :user_info_edit_part => :edit_collection_new )
          }

          format.json { render json: { status: :ko, msg: @collection.errors.full_messages.first }, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = I18n.t(:create_with_existing_name, scope: :edit_collection_new)
          redirect_to new_collection_user_path(current_user, :user_info_edit_part => :edit_collection_new )
        }

        format.json { render json: { status: :ko, msg: I18n.t(:create_with_existing_name, scope: :edit_collection_new) }, status: :unprocessable_entity }
      end
    end
  end

  def update
    existing = current_user.oCollections.select { |c| (not c.id.to_s.eql?(params[:id])) and c.name == collection_params[:name] }

    unless existing.size > 0
      respond_to do |format|
        if @collection.update(collection_params)
          format.html {
            flash[:success] = I18n.t(:update_ok, scope: :edit_collection)
            redirect_to show_collections_user_path(current_user, :user_info_edit_part => :edit_collection)
          }

          format.json { render json: { status: :ok }, status: :ok }
        else
          format.html {
            flash[:error] = I18n.t(:update_ko, scope: :edit_collection)
            redirect_to edit_collection_user_path(@collection, :user_info_edit_part => :edit_collection_update)
          }

          format.json { render json: { status: :ko }, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = I18n.t(:update_with_existing_name, scope: :edit_collection)
          redirect_to edit_collection_user_path(@collection, :user_info_edit_part => :edit_collection_update)
        }

        format.json { render json: { status: :ko }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @collection && @collection.destroy
      respond_to do |format|
        format.html { redirect_to show_collections_user_path(current_user, :user_info_edit_part => :edit_collection) }
        format.json { render json: { status: :ok }, status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: { status: :ko }, status: :unprocessable_entity }
      end
    end
  end

  def show_my_collections
    @collections = current_user.oCollections

    respond_to do |format|
      format.json { render :index, status: :ok }
    end
  end

  def show_liked_by_me
    @collections = current_user.liked_collections

    respond_to do |format|
      format.json { render :index, status: :ok }
    end
  end

  def like_collection
    if @collection && @collection.public && @collection.user != current_user
      current_user.liked_collections.push(@collection)
      if current_user.save
        respond_to do |format|
          format.json { render json: { status: :ok }, status: :ok }
        end

        return
      end
    else
      respond_to do |format|
        format.json { render json: { status: :ko }, status: :unprocessable_entity }
      end
    end
  end

  def dislike_collection
    if @collection && @collection.user != current_user
      current_user.liked_collections.delete(@collection)
      if current_user.save
        respond_to do |format|
          format.json { render json: { status: :ok }, status: :ok }
        end

        return
      end
    else
      respond_to do |format|
        format.json { render json: { status: :ko }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def collection_params
    params.require(:collection).permit(:name, :desc, :img, :public)
  end
end
