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

  def edit
    if params[:user_info_edit_part] == :edit_password_by_admin.to_s
      @user = User.find(params[:user_id])
    end
  end

  def create
    @user = User.new(user_params)
    @user.save
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
