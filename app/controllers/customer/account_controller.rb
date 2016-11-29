class Customer::AccountController < ApplicationController

  authorize_resource :class => false
  before_action :set_user

  layout :custom_sublayout

  attr_accessor :user

  def edit
  end

  # NOTE : this update is used from many different points
  # within the system (e.g checkout process) be careful with this.
  def update
    if check_valid_password?(params) && user.update(user_params)
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

  # TODO : we should refactor this into something better
  def user_params
    check_password! unless user.wechat?
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :fname, :lname, :birth, :gender, :about, :website, :pic, :tel, :mobile)
  end

  def check_valid_password?(params)
    return true if user.wechat?
    if user.valid_password?(params[:user][:current_password])
      true
    else
      user.errors.add(:password, "wrong")
      false
    end
  end

  def check_password!
    if params[:user][:password].empty?
      params[:user][:password] = params[:user][:password_confirmation] = params[:user][:current_password]
    end
  end

end
