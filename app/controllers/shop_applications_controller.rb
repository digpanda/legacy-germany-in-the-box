require "uri"
require "net/http"

class ShopApplicationsController < ApplicationController

  before_action :authenticate_user!, except: [:new, :create, :is_registered]

  #before_action(only: [:new])  { I18n.locale = :de }

  before_action :set_shop_application, only: [:show, :destroy]
  layout :custom_sublayout, only: [:index, :show]

  def index
    @shop_applications = ShopApplication.all
  end

  def destroy

    unless @shop_application.destroy
      return throw_model_error(@shop_application)
    end

    flash[:success] = I18n.t(:delete_ok, scope: :edit_shop_application)
    redirect_to(:back)
  end

  private

  def shop_application_params
    params.require(:shop_application).permit(:email, :name, :shopname, :desc, :philosophy, :stories, :german_essence, :uniqueness, :founding_year, :register, :website, :fname, :lname, :tel, :mobile, :mail, :function)
  end

  def set_shop_application
    @shop_application = ShopApplication.find(params[:id])
  end

end
