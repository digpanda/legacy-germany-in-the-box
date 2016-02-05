class UsersController < ApplicationController

  before_action :set_user, except: [:search_users,
                                    :openmailnoti,
                                    :getuserbyid,
                                    :index,
                                    :new,
                                    :create,
                                    :addprodtocol,
                                    :getuserbyemail]

  skip_before_filter :authenticate_user!, only: :index

  acts_as_token_authentication_handler_for User, except: [:search_users,
                                                          :index,
                                                          :get_followers,
                                                          :get_followings]

  include Base64ToUpload

  before_action(:only =>  [:create, :update]) {
    base64_to_uploadedfile :user, :pic
  }

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html {  }
      format.json { render :index }
    end
  end

  def show
  end

  def pshow

  end

  def getuserbyemail
    @user = User.where(email: user_search[:email]).first

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
    if params[:user_info_edit_part] == :edit_address.to_s
      @address = Address.new
    elsif params[:user_info_edit_part] == :edit_collection_new.to_s
      @collection = Collection.new
    elsif params[:user_info_edit_part] == :edit_collection_update.to_s
      @collection = Collection.find(params[:collection_id])
    end
  end

  def openmailnoti

  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.save
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params.except(:email, :username))
        format.html {
          render :edit, user_info_edit_part: params[:user_info_edit_part]
        }

        format.json { render :show, status: :ok, location: @user }
      else
        format.html {
          if @user.errors.any?
            flash[:error] ||= @user.errors.full_messages.first
          end

          render :edit, user_info_edit_part: params[:user_info_edit_part]

          flash.delete(:error)
        }

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

  def get_followers
    @users = @user.followers

    respond_to do |format|
      format.html { render :index }
      format.json { render :get_followers }
    end
  end

  def get_followings
    @users = @user.following

    respond_to do |format|
      format.html { render :index }
      format.json { render :get_followings }
    end

  end

  def search_users
    @users = User.or({username: /.*#{params[:users_search_keyword]}.*/i},
                     {fname: /.*#{params[:users_search_keyword]}.*/i},
                     {email: /.*#{params[:users_search_keyword]}.*/i}).limit(Rails.configuration.limit_for_users_search)

    respond_to do |format|
      format.html { render :index }
      format.json { render :search_users }
    end
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    gender = params.require(:user)[:gender]

    if not gender.present?
      gender = 'f'
    elsif ['female', 'f', 'false'].include?(gender.downcase)
      gender = 'f'
    elsif ['male', 'm', 'true'].include?(gender.downcase)
      gender = 'm'
    end

    params.require(:user).permit(:username, :email, :parse_id, :password, :password_confirmation, :fname, :lname, :birth, :gender, :about, :website, :country, :pic, :lang, :provider ,:uid, :tel, :mobile)
  end

  def user_search
    params.require(:user).permit(:email)
  end

end
