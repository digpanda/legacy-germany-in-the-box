require "uri"
require "net/http"

class ShopApplicationsController < ApplicationController

  before_action :authenticate_user!, except: [:new, :create, :registered?]

  before_action(only: [:new])  { I18n.locale = :de }

  before_action :set_shop_application, only: [:show, :destroy]

  def index
    @applications = ShopApplication.all
    render :index, layout: "#{current_user.role.to_s}_sublayout"
  end

  def show
    render :show, layout: "#{current_user.role.to_s}_sublayout"
  end

  def new
    @shop_application = ShopApplication.new
    render :new, layout: 'default_sublayout'
  end

  def create
    @shop_application = ShopApplication.new(shop_application_params)

    if @shop_application.save
      user = {}
      user[:username] = params[:shop_application][:email]
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

    redirect_to new_shop_application_path(:finished => true)
  end

  def destroy
    if  @shop_application.destroy
      flash[:success] = I18n.t(:delete_ok, scope: :edit_shop_application)
    else
      flash[:error] = @shop_application.errors.full_messages.first
    end

    redirect_to request.referer
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
    params.require(:shop_application).permit(:email, :name, :shopname, :desc, :philosophy, :stories, :german_essence, :uniqueness, :founding_year, :register, :website, :fname, :lname, :tel, :mobile, :mail, :function, sales_channels:[])
  end

  def set_shop_application
    @shop_application = ShopApplication.find(params[:id])
  end
end