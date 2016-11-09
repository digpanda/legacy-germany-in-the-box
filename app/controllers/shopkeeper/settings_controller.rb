class Shopkeeper::SettingsController < ApplicationController

  load_and_authorize_resource :class => false
  layout :custom_sublayout
  before_action :set_shop

  attr_reader :shop

  def index
  end

  def update
    if shop.update(shop_params)
      flash[:success] = I18n.t(:update_agb_ok, scope: :edit_shop)
      redirect_to shopkeeper_shop_path
      return
    end
    flash[:error] = shop.errors.full_messages.first
    redirect_to navigation.back(1)
  end

  private

  def set_shop
    @shop = current_user.shop
  end

  def shop_params
      params.require(:shop).permit!.delocalize({:min_total => :number})
  end

end
