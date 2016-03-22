require "uri"
require "net/http"

class ShopApplicationController < ApplicationController

  before_action :authenticate_user!, except: [:index, :new, :create, :registered?]

  before_action :set_locale

  def new
  end

  def create
    @shop_application = ShopApplication.new(shop_application_params)

    if @shop_application.save
      user = {}
      user[:username] = params[:shop_application][:name]
      user[:email] = params[:shop_application][:email]
      user[:password] = @shop_application.code[0, 8]
      user[:password_confirmation] = @shop_application.code[0, 8]
      user[:role] = :shopkeeper

      @user = User.new(user)

      unless @user.save
        flash[:error] = @user.errors.full_messages.first
      else
        @shop = Shop.new(shop_application_params.except(:email, :fname, :lname, :tel, :mobile, :mail, :function))
        @shop.shopkeeper = @user
        unless @shop.save
          flash[:error] = @shop.errors.full_messages.first
        end
      end
    else
      flash[:error] = @shop_application.errors.full_messages.first
    end

    redirect_to shop_application_index_path(:finished => true)
  end

  def index
    render :new
  end

  def registered?
    respond_to do |format|
      if User.where(:email => shop_application_params[:email]).count == 0
        format.json { render :json => {}, status: :ok}
      else
        format.json { render :json => {}, status: :found}
      end
    end
  end

  private

  def shop_application_params
    params.require(:shop_application).permit(:email, :name, :shopname, :desc, :philosophy, :stories, :founding_year, :register, :website, :statement0, :statement1,  :statement2, :fname, :lname, :tel, :mobile, :mail, :german_essence, :uniqueness, :function)
  end

  def set_locale
    I18n.locale = :de
  end
end