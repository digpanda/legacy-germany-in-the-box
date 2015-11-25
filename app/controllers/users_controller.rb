class UsersController < ApplicationController
  #skip_before_action :verify_authenticity_token
  before_action :set_user, except: [:userssearch, :openmailnoti,:removeprodtocol, :getuserbyid, :index, :new, :create, :addprodtocol, :getuserbyemail]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def pshow

  end

  def getuserbyemail
    @user = User.where(email: user_search[:email]).first
    # @user = User.where(email: params[:email]).first
    respond_to do |format|
      format.html { redirect_to products_path }
      format.json { render :show, status: :created, location: @user }
    end
  end

  def getuserbyid
    @user = User.where(parse_id: params[:parse_id]).first
    # @user = User.where(email: params[:email]).first
    respond_to do |format|
      format.html { redirect_to products_path }
      format.json { render :show, status: :created, location: @user }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user=User.find(params[:id])
  end


def openmailnoti

end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to products_path }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      username format.json { head :no_content }
    end
  end


  # Friends

  def follow
    @user.following << User.find(params[:target_id])
    @user.save
    @target = User.find(params[:target_id])
    @target.followers << User.find(params[:id])
    @target.save
    @msg = "Done"
    respond_to do |format|
      format.json { render :msg, status: :ok, location: @user }
    end
  end

  def unfollow
    @user.following.delete(params[:target_id])
    @user.save
    @target = User.find(params[:target_id])
    @target.followers.delete(params[:id])
    @target.save
    @msg = "Done"
    respond_to do |format|
      format.json { render :msg, status: :ok, location: @user }
    end
  end


  # Collections

  def savecol
    @collection = Collection.find(params[:col_id])
    @user.saved_Collections.push(@collection)
    @user.save
    @msg = "Done"
    respond_to do |format|
      format.html { redirect_to collections_path }
      format.json { render :msg, status: :ok, location: @user }
    end
  end

  def unsavecol
    @user.saved_collections.delete(params[:col_id])
    @user.save
    @msg = "Done"
    respond_to do |format|
      format.json { render :msg, status: :ok, location: @user }
    end
  end

  def likecol
    @user.liked_collections << params[:col_id]
    @user.save
    @col = Collection.find(params[:col_id])
    @col.likers << params[:id]
    @col.save
    @msg = "Done"
    respond_to do |format|
      format.json { render :msg, status: :ok, location: @user }
    end
  end

  def dislikecol
    @user.liked_collections.delete(params[:col_id])
    @user.save
    @col = Collection.find(params[:col_id])
    @col.likers.delete(params[:id])
    @col.save
    @msg = "Done"
    respond_to do |format|
      format.json { render :msg, status: :ok, location: @user }
    end
  end

  # products

  def saveprod
    @user.products << Product.find(params[:prod_id])
    @user.save
    @msg = "Done"
    respond_to do |format|
      format.json { render :msg, status: :ok, location: @user }
    end
  end

  def unsaveprod
    @user.products.delete(Product.find(params[:prod_id]))
    @user.save
    @msg = "Done"
    respond_to do |format|
      format.json { render :msg, status: :ok, location: @user }
    end
  end

  def likeprod
    @user.liked_products << params[:prod_id]
    @user.save
    @prod = Product.find(params[:prod_id])
    @prod.likers << params[:id]
    @prod.save
    @msg = "Done"
    respond_to do |format|
      format.json { render :msg, status: :ok, location: @user }
    end
  end

  def dislikeprod
    @user.liked_products.delete(params[:prod_id])
    @user.save
    @prod = Product.find(params[:prod_id])
    @prod.likers.delete(params[:id])
    @prod.save
    @msg = "Done"
    respond_to do |format|
      format.json { render :msg, status: :ok, location: @user }
    end
  end

  # chats

  def joinprivatechat
    @user.private_chats << params[:chat_id]
    @user.save
    @chat = Chat.find(params[:chat_id])
    @chat.chatters << params[:id]
    @chat.save
    @msg = "Done"
    respond_to do |format|
      format.json { render :msg, status: :ok, location: @user }
    end
  end

  def leaveprivatechat
    @user.private_chats.delete(params[:chat_id])
    @user.save
    @chat = Chat.find(params[:chat_id])
    @chat.chatters.delete(params[:id])
    @chat.save
    @msg = "Done"
    respond_to do |format|
      format.json { render :msg, status: :ok, location: @user }
    end
  end

  def joinpublicchat
    @user.public_chats << params[:chat_id]
    @user.save
    @chat = Chat.find(params[:chat_id])
    @chat.chatters << params[:id]
    @chat.save
    @msg = "Done"
    respond_to do |format|
      format.json { render :msg, status: :ok, location: @user }
    end
  end

  def leavepublicchat
    @user.public_chats.delete(params[:chat_id])
    @user.save
    @chat = Chat.find(params[:chat_id])
    @chat.chatters.delete(params[:id])
    @chat.save
    @msg = "Done"
    respond_to do |format|
      format.json { render :msg, status: :ok, location: @user }
    end
  end


  def addprodtocol
    @product = Product.find(params[:prod_id])
    @collection = Collection.find(params[:col_id])
    @collection.products << params[:prod_id]
    @collection.products_imgs << @product.img
    @collection.save
    @msg = "Done"
    respond_to do |format|
      format.json { render :msg, status: :ok, location: @user }
    end

  end

  def removeprodtocol
    @product = Product.find(params[:prod_id])
    @collection = Collection.find(params[:col_id])
    @collection.products.delete(params[:prod_id])
    @collection.products_imgs.delete(@product.img)
    @collection.save
    @msg = "Done"
    respond_to do |format|
      format.json { render :msg, status: :ok, location: @user }
    end

  end


  def getfollowers
    @users = []
    @user.followers.each do |i|
      @follower = User.find (i)
      @users << @follower
    end
    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @user }
    end

  end

  def getfollowings
    @users = []
    @user.following.each do |i|
      @follower = User.find (i)
      @users << @follower
    end

    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @user }
    end

  end

  def userssearch
    if (params[:folds] == "0")
      @users = User.or({username: /.*#{params[:keyword]}.*/i}, {fname: /.*#{params[:keyword]}.*/i}, {email: /.*#{params[:keyword]}.*/i}).limit(50)
    else
      @i = params[:folds].to_i
      @users = User.or({username: /.*#{params[:keyword]}.*/i}, {fname: /.*#{params[:keyword]}.*/i}, {email: /.*#{params[:keyword]}.*/i}).skip(@i*50).limit(50)
      # @products = Product.search(params[:keyword]).order("created_at DESC")
    end
    # @products << Product.where(name: params[:keyword])
    # @products << Product.where(category: params[:keyword])

    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @user }
    end

  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :email, :parse_id, :password, :fname, :lname, :birth, :gender, :about, :website, :country, :pic, :lang, :provider ,:uid)
  end

  def user_search
    params.require(:user).permit(:email)
  end


end
