require "uri"
require "net/http"

class ShopApplicationsController < ApplicationController

  before_action :authenticate_user!, except: [:new, :create, :is_registered]

  #respond_to :js, only: [:is_registered]
  #before_action(only: [:new])  { I18n.locale = :de }

  before_action :set_shop_application, only: [:show, :destroy]

  def index
    @applications = ShopApplication.all
    render :index, layout: "sublayout/_#{current_user.role.to_s}"
  end

  def show
    render :show, layout: "sublayout/_#{current_user.role.to_s}"
  end

  def new
    @shop_application = ShopApplication.new
  end

  def create

    @shop_application = ShopApplication.new(shop_application_params)

    unless @shop_application.save
      return throw_model_error(@shop_application)
    end

    @user = User.new({

      :username => params[:shop_application][:email],
      :email => params[:shop_application][:email],
      :password => @shop_application.code[0, 8],
      :password_confirmation => @shop_application.code[0, 8],
      :role => :shopkeeper

    })

    unless @user.save
      return throw_model_error(@user)
    end

    @shop = Shop.new(shop_application_params.except(:email))
    @shop.shopname = @shop.name
    @shop.shopkeeper = @user
    @shop.merchant_id = @shop.gen_merchant_id

    unless @shop.save
      return throw_model_error(@shop)
    end

    redirect_to new_shop_application_path(:finished => true)
  end

  def destroy

    unless @shop_application.destroy
      return throw_model_error(@shop_application)
    end

    flash[:success] = I18n.t(:delete_ok, scope: :edit_shop_application)
    redirect_to(:back) and return
  end

  private

  def shop_application_params
    params.require(:shop_application).permit(:email, :name, :shopname, :desc, :philosophy, :stories, :german_essence, :uniqueness, :founding_year, :register, :website, :fname, :lname, :tel, :mobile, :mail, :function, sales_channels:[])
  end

  def set_shop_application
    @shop_application = ShopApplication.find(params[:id])
  end
end