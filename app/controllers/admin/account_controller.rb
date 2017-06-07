class Admin::AccountController < ApplicationController

  attr_accessor :user

  authorize_resource :class => false
  before_action :set_user

  layout :custom_sublayout

  def edit
  end

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

  def user_params
    bypass_password!
    params.require(:user).permit!
  end

  def check_valid_password?(params)
    if user.valid_password?(params[:user][:current_password])
      true
    else
      user.errors.add(:password, "wrong")
      false
    end
  end

  def bypass_password!
    if params[:user][:password].empty?
      params[:user][:password] = params[:user][:password_confirmation] = params[:user][:current_password]
    end
  end

end
