class Admin::ShopApplicationsController < ApplicationController

  attr_accessor :shop_application, :shop_applications

  authorize_resource class: false
  before_action :set_shop_application, :except => [:index]

  layout :custom_sublayout

  def index
    @shop_applications = ShopApplication.order_by(c_at: :desc).paginate(page: current_page, per_page: 10)
  end

  def destroy
    unless shop_application.destroy
      return throw_model_error(shop_application)
    end
    flash[:success] = I18n.t(:delete_ok, scope: :edit_shop_application)
    redirect_to navigation.back(1)
  end

  private

  def shop_application_params
    params.require(:shop_application).permit!
  end

  def set_shop_application
    @shop_application = ShopApplication.find(params[:id] || params[:shop_application_id])
  end

end
