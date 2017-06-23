class Admin::UsersController < ApplicationController

  attr_accessor :user, :users

  authorize_resource :class => false
  before_action :set_user, :except => [:index, :emails]

  layout :custom_sublayout

  before_action :breadcrumb_admin_users, :except => [:index]
  before_action :breadcrumb_admin_user, only: [:show]

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
      user&.referrer&.destroy # if it's also a referrer
      flash[:success] = "The user account was successfully destroyed."
    else
      flash[:error] = "The user was not destroyed (#{user.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  def emails
    users = User.all
    @customers_emails_list = users.where(role: :customer).emails_list
    @shopkeepers_emails_list = users.where(role: :shopkeeper).emails_list
    @admins_emails_list = users.where(role: :admin).emails_list
  end

  def set_as_referrer
    referrer = Referrer.create(user: user)
    Coupon.create_referrer_coupon(referrer) if referrer.coupons.empty?
    flash[:success] = "The user account was successfully set as a tourist guide."

    redirect_to navigation.back(1)
  end

  def force_login
    sign_in(user)
    redirect_to SigninHandler.new(request, navigation, user, cart_manager).solve!
  end

  private

  def set_user
    @user = User.find(params[:id] || params[:user_id])
  end

  def user_params
    params.require(:user).permit!
  end

end
