class Shopkeeper::ShopController < ApplicationController

  # TODO : this is not a good way to tackle the problem
  # the structure of the model itself should be changed
  # this is pathetic to have such fields in the database.
  # we are not a bunch of amateurs.
  # - Laurent
  SHOP_IMAGE_FIELDS = [:logo, :banner, :seal0, :seal1, :seal2, :seal3, :seal4, :seal5, :seal6, :seal7]

  authorize_resource :class => false
  layout :custom_sublayout
  before_action :set_shop

  attr_reader :shop

  def show
  end

  def update
    if shop.agb && shop.update(shop_params)
      flash[:success] = I18n.t(:update_ok, scope: :edit_shop)
      redirect_to navigation.back(1)
    else
      flash[:error] = shop.errors.full_messages.first
      redirect_to navigation.back(1)
    end
  end

  def destroy_image
    if ImageDestroyer.new(shop, SHOP_IMAGE_FIELDS).perform(params[:image_field])
      flash[:success] = I18n.t(:removed_image, scope: :action)
    else
      flash[:error] = I18n.t(:no_removed_image, scope: :action)
    end
    redirect_to navigation.back(1)
  end

  private

  def set_shop
    @shop ||= current_user.shop
  end

  def shop_params
    params.require(:shop).permit!.except(:agb).delocalize({:min_total => :number})
  end

end
