class Shopkeeper::ShopController < ApplicationController
  include DestroyImage

  attr_reader :shop

  authorize_resource class: false
  before_action :set_shop

  layout :custom_sublayout

  def show
  end

  def update
    if shop.agb && shop.update(shop_params)
      flash[:success] = I18n.t(:update_ok, scope: :edit_shop)
    else
      flash[:error] = shop.errors.full_messages.join(', ')
    end
    redirect_to navigation.back(1)
  end

  private

  def set_shop
    @shop = current_user.shop
  end

  def shop_params
    params.require(:shop).permit!.except(:agb)
  end
end
