require "uri"
require "net/http"

class Guest::ShopApplicationsController < ApplicationController

  attr_reader :shop_application

  def new
    @shop_application = ShopApplication.new
  end

  def create

    @shop_application = ShopApplication.new(shop_application_params)
    return throw_model_error(shop_application, :new) unless shop_application.save

    user = User.new({

      :username => params[:shop_application][:email],
      :email => params[:shop_application][:email],
      :password => shop_application.code[0, 8],
      :password_confirmation => shop_application.code[0, 8],
      :role => :shopkeeper

    })

    unless user.save
      shop_application.delete
      return throw_model_error(@user, :new)
    end

    shop = Shop.new(shop_application_params.except(:email))
    shop.shopname = shop.name
    shop.shopkeeper = user

    unless shop.save
      shop_application.delete
      user.delete
      return throw_model_error(shop, :new)
    end

    flash[:success] = I18n.t(:no_applications, scope: :edit_shop_application)
    redirect_to navigation_history(2) and return

  end

  private

  def shop_application_params
    params.require(:shop_application).permit(:email, :name, :shopname, :desc, :philosophy, :stories, :german_essence, :uniqueness, :founding_year, :register, :website, :fname, :lname, :tel, :mobile, :mail, :function)
  end

end