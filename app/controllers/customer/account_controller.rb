class Customer::AccountController < ApplicationController

  authorize_resource :class => false
  before_action :set_user

  layout :custom_sublayout

  attr_accessor :user

  def edit
  end

  def update
    if user.check_valid_password?(params) && user.update(user_params)
      flash[:success] = "Your account was successfully updated."
      sign_in(user, :bypass => true)
    else
      flash[:error] = user.errors.full_messages.join(',')
    end
    redirect_to navigation.back(1)
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    if params[:user][:password].empty?
      params[:user][:password] = params[:user][:password_confirmation] = params[:user][:current_password]
    end
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :fname, :lname, :birth, :gender, :about, :website, :pic, :tel, :mobile)
  end

end
