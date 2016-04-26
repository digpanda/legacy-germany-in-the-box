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

  include Base64ToUpload

  before_action(:only =>  [:create, :update]) {
    base64_to_uploadedfile :user, :pic
  }

  def index

    @users = User.all

    respond_to do |format|
      format.html { render :index, layout: "#{current_user.role.to_s}_sublayout" }
      format.json { render :index }
    end
  end

  def show

    @user = User.find(params[:id])
    
    respond_to do |format|
      format.json {
        render :json => { :status => :ok, :user => @user }
      }
    end

  end

  def new
    @user = User.new
  end

  def edit_account
    if current_user.id.to_s == @user.id.to_s
      render :edit_account, layout: "#{current_user.role.to_s}_sublayout"
    elsif current_user.role == :admin
      render :edit_account_by_admin, layout: "#{current_user.role.to_s}_sublayout"
    end
  end

  def edit_personal
    render :edit_personal, layout: "#{current_user.role.to_s}_sublayout"
  end

  def edit_bank
    render :edit_bank, layout: "#{current_user.role.to_s}_sublayout"
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
      respond_to do |format|
        if ups[:password] && @user.update_with_password(ups.except(:email))
          format.html {
            flash[:success] = I18n.t(:update_password_ok, scope: :edit_personal)
            sign_in(@user, :bypass => true)
            redirect_to request.referer
          }

          format.json { render :show, status: :ok, location: @user }
        elsif ups[:password].blank? && @user.update_without_password(ups.except(:email))
          format.html {
            flash[:success] = I18n.t(:update_ok, scope: :edit_personal)
            redirect_to request.referer
          }

          format.json { render :show, status: :ok, location: @user }
        else
          format.html {
            if @user.errors.any?
              flash[:error] ||= @user.errors.full_messages.first
            end

            redirect_to request.referer

            flash.delete(:error)
          }

          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    elsif current_user.role == :admin
      if ups[:password] && @user.update(ups.except(:email))
        respond_to do |format|
          format.html {
            flash[:success] = I18n.t(:update_password_ok, scope: :edit_personal)
            redirect_to request.referer
          }
        end
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
      respond_to do |format|
        format.html {
          flash[:success] = I18n.t(:follow_ok, scope: :edit_following)
          redirect_to request.referer
        }
        format.json { render :json => { status: :ok }, status: :ok}
      end
    else
      respond_to do |format|
        format.html {
          flash[:success] = I18n.t(:follow_ko, scope: :edit_following)
          redirect_to request.referer
        }
        format.json { render :json => { status: :ko }, status: :unprocessable_entity}
      end
    end
  end

  def unfollow
    @target = @user
    @target.followers.delete(current_user)
    current_user.following.delete(@target)

    if @target && @target != current_user && @target.save && current_user.save
      respond_to do |format|
        format.html {
          flash[:success] = I18n.t(:unfollow_ok, scope: :edit_following)
          redirect_to request.referer
        }
        format.json { render :json => { status: :ok }, status: :ok}
      end
    else
      respond_to do |format|
        format.html {
          flash[:success] = I18n.t(:follow_ko, scope: :edit_following)
          redirect_to request.referer
        }
        format.json { render :json => { status: :ko }, status: :unprocessable_entity}
      end
    end
  end

  def get_followers

    @user = User.find(params[:id])
    @followers = @user.followers.without_detail

    followers_with_reciprocity = JsonIntegrate.followers_reciprocity(@user, followers)

    respond_to do |format|
      format.html { render :index }
      format.json { render :json => ApiFormat.success(:followers, followers_with_reciprocity) }
    end

  end

  def get_following

    @user = User.find(params[:id]) 

    respond_to do |format|
      format.html { render :index }
      format.json { render :json => ApiFormat.success(:followers, user.following) }
    end

  end

  def search
    @users = User.or({username: /.*#{params[:keyword]}.*/i},
                     {fname: /.*#{params[:keyword]}.*/i},
                     {email: /.*#{params[:keyword]}.*/i}).limit(Rails.configuration.limit_for_users_search)

    respond_to do |format|
      format.html { render :index }
      format.json { render :search }
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
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
