class UsersController < ApplicationController

  attr_reader :followers

  before_action :authenticate_user!, except: [:search,
                                              :get_followers,
                                              :get_following]

  load_and_authorize_resource

  before_action :set_user, except: [:search,
                                    :index,
                                    :new,
                                    :create]

  include Base64ToUpload

  layout :custom_sublayout, only: [:edit_account, :edit_personal, :favorites]

  before_action(:only =>  [:create, :update]) {
    base64_to_uploadedfile :user, :pic
  }

  def show
  end

  def new
    @user = User.new
  end

  def edit_account
    if current_user.id.to_s == @user.id.to_s
      render :edit_account
    elsif current_user.decorate.admin?
      render 'users/admin/edit_account_by_admin'
    end
  end

  def edit_personal
    render :edit_personal
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

  # TODO : this will be removed
  # it's already not in used anymore for the customer
  def update

    ups = user_params

    if current_user.id.to_s == @user.id.to_s
      if ups[:password] && @user.decorate.update_with_password(ups)

        flash[:success] = I18n.t(:update_password_ok, scope: :edit_personal)
        sign_in(@user, :bypass => true)
        redirect_to request.referer


      elsif ups[:password].blank? && @user.update_without_password(ups)

        flash[:success] = I18n.t(:update_ok, scope: :edit_personal)
        redirect_to request.referer

      else
        if @user.errors.any?
          flash[:error] ||= @user.errors.full_messages.first
        end

        redirect_to request.referer

        flash.delete(:error)

      end
    elsif current_user.decorate.admin?
      if ups[:password] && @user.update(ups)
        flash[:success] = I18n.t(:update_password_ok, scope: :edit_personal)
        redirect_to request.referer
      end
    end
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
