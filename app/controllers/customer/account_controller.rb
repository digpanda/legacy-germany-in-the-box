class Customer::AccountController < ApplicationController

  attr_accessor :user

  authorize_resource :class => false
  before_action :set_user

  layout :custom_sublayout, except: [:missing_info]

  def edit
  end

  # NOTE : this update is used from many different points
  # within the system (e.g checkout process) be careful with this.
  def update
    if valid_password? && ensure_password! && user.update(user_params)
      flash[:success] = I18n.t("message.account_updated")
      sign_in(user, :bypass => true)
    else
      flash[:error] = user.errors.full_messages.join(',')
    end
    redirect_to navigation.back(1)
  end

  def menu
  end

  # missing details / informations the user needs to fill in
  def missing_info
    unless current_user.missing_info?
      # NOTE : the missing info can be triggered from multiple points
      # therefore it's just better to get back to the origin url.
      redirect_to identity_solver.origin_url
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :fname, :lname, :birth, :gender, :about, :website, :pic, :mobile)
  end

  def password_needed?
    !user.wechat? && params[:user][:password].present?
  end

  def valid_password?
    return true unless password_needed?
    if user.valid_password?(params[:user][:current_password])
      true
    else
      user.errors.add(:password, "wrong")
      false
    end
  end

  def ensure_password!
    unless password_needed?
      params[:user][:password] = params[:user][:password_confirmation] = params[:user][:current_password]
    end
    true
  end

end
