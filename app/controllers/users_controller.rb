class UsersController < ApplicationController

  attr_reader :followers

  before_action :authenticate_user!, except: [:search,
                                              :index,
                                              :get_followers,
                                              :get_following]

  load_and_authorize_resource

  before_action :set_user, except: [:search,
                                    :index,
                                    :new,
                                    :create]

  layout :custom_sublayout, only: [:favorites]

  include Base64ToUpload

  layout :custom_sublayout, only: [:index, :edit_account, :edit_personal, :edit_bank, :favorites]

  before_action(:only =>  [:create, :update]) {
    base64_to_uploadedfile :user, :pic
  }

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit_account
    if current_user.id.to_s == @user.id.to_s
      render :edit_account
    elsif current_user.is_admin?
      render 'users/admin/edit_account_by_admin'
    end
  end

  def edit_personal
    render :edit_personal
  end

  def edit_bank
    render :edit_bank
  end

  def edit
    if params[:user_info_edit_part] == :edit_password_by_admin.to_s
      @user = User.find(params[:user_id])
    end
  end

  def create
    @user = User.new(user_params)
    @user.save
  end

  def update
    ups = user_params

    if current_user.id.to_s == @user.id.to_s
      if ups[:password] && @user.update_with_password(ups.except(:email))

        flash[:success] = I18n.t(:update_password_ok, scope: :edit_personal)
        sign_in(@user, :bypass => true)
        redirect_to request.referer


      elsif ups[:password].blank? && @user.update_without_password(ups.except(:email))

        flash[:success] = I18n.t(:update_ok, scope: :edit_personal)
        redirect_to request.referer

      else
        if @user.errors.any?
          flash[:error] ||= @user.errors.full_messages.first
        end

        redirect_to request.referer

        flash.delete(:error)

      end
    elsif current_user.is_admin?
      if ups[:password] && @user.update(ups.except(:email))
        flash[:success] = I18n.t(:update_password_ok, scope: :edit_personal)
        redirect_to request.referer
      end
    end
  end

  def destroy
    if  @user.oCollections.delete_all && @user.addresses.delete_all && @user.destroy
      flash[:success] = I18n.t(:delete_ok, scope: :edit_accounts)
    else
      flash[:error] = @user.errors.full_messages.first
    end

    redirect_to request.referer
  end

  def follow

    @target = @user
    @target.followers.push(current_user)
    current_user.following.push(@target)

    if @target && @target != current_user && @target.save && current_user.save

      flash[:success] = I18n.t(:follow_ok, scope: :edit_following)
      redirect_to request.referer

    else

      flash[:success] = I18n.t(:follow_ko, scope: :edit_following)
      redirect_to request.referer

    end
  end

  def unfollow
    @target = @user
    @target.followers.delete(current_user)
    current_user.following.delete(@target)

    if @target && @target != current_user && @target.save && current_user.save
      flash[:success] = I18n.t(:unfollow_ok, scope: :edit_following)
      redirect_to request.referer
    else
      flash[:success] = I18n.t(:follow_ko, scope: :edit_following)
      redirect_to request.referer
    end
  end

  def get_followers
    @followers = @user.followers.without_detail
    followers_with_reciprocity = followers_reciprocity(@user, followers)
    render :index
  end

  # SHOULD BE IN THE MODEL -> WE SHOULD ACTUALLY REDO THE WHOLE FOLLOWING SYSTEM
  def followers_reciprocity(user, followers)
    followers.map { |f| f.as_json.merge({:reciprocity => (f.followers.include? user._id)}) }
  end

  def get_following
    render :index
  end

  def search
    @users = User.or({username: /.*#{params[:keyword]}.*/i},
                     {fname: /.*#{params[:keyword]}.*/i},
                     {email: /.*#{params[:keyword]}.*/i}).limit(Rails.configuration.limit_for_users_search)

    render :index
  end


  private

  def set_user
    @user = User.find(params[:id]) unless params[:id].nil?
  end

  def user_params
    gender = params.require(:user)[:gender]

    if not gender.present?
      gender = 'f'
    elsif ['female', 'f', 'false'].include?(gender.downcase)
      gender = 'f'
    elsif ['male', 'm', 'true'].include?(gender.downcase)
      gender = 'm'
    end

    params.require(:user).permit(:username, :email, :current_password, :password, :password_confirmation, :fname, :lname, :birth, :gender, :about, :website, :pic, :tel, :mobile)
  end

end
