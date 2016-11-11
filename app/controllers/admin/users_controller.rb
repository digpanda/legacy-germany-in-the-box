class Admin::UsersController < ApplicationController

  authorize_resource :class => false
  before_action :set_user, :except => [:index]

  layout :custom_sublayout

  attr_accessor :user, :users

  def index
    @users = User.order(last_sign_in_at: :desc).paginate(:page => current_page, :per_page => 10)
  end

  def show
  end

  def update
    if user.update(user_params)
      flash[:success] = "The user was updated."
    else
      flash[:error] = "The user was not updated (#{user.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  def destroy
    if user.destroy
      flash[:success] = "The user account was successfully destroyed."
    else
      flash[:error] = "The user was not destroyed (#{user.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  private

  def set_user
    @user = User.find(params[:id] || params[:user_id])
  end

  def user_params
    params.require(:user).permit!
  end

end
