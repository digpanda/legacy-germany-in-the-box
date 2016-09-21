class Shopkeeper::UserController < ApplicationController

  load_and_authorize_resource
  before_action :set_user

  layout :custom_sublayout

  attr_accessor :user

  def edit
  end

  def update
    if valid_password? && user.update(user_params)
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

  def valid_password?
    if user.valid_password?(params[:user][:current_password])
      true
    else
      user.errors.add(:password, "not matching")
      false
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :fname, :lname, :tel, :mobile)
  end

end
