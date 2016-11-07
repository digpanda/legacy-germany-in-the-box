class ShopsController <  ApplicationController

  SHOP_IMAGE_FIELDS = [:logo, :banner, :seal0, :seal1, :seal2, :seal3, :seal4, :seal5, :seal6, :seal7]

  before_action :authenticate_user!, except: [:show]
  before_action :set_shop, :set_category, except: [:index]

  layout :custom_sublayout, only: [:index, :edit_setting, :edit_producer, :show_products]

  load_and_authorize_resource

  attr_reader :shop, :shops

  # def index
  #   @shops = Shop.in(shopkeeper: User.where(role: 'shopkeeper').map { |u| u.id} ).all;
  # end
  #
  def show
    redirect_to guest_shop_path(shop)
  end

  def edit_setting
  end

  def edit_producer
    @producer = shop
  end

  def show_products
  end

  def update
    sp = shop_params(@shop)

    if shop.agb && shop.update(sp)
      flash[:success] = I18n.t(:update_ok, scope: :edit_shop)
      redirect_to navigation.back(1)
    elsif (!shop.agb) && shop.update(sp)
      flash[:success] = I18n.t(:update_agb_ok, scope: :edit_shop)
      redirect_to edit_setting_shop_path(shop)
    else
      flash[:error] = shop.errors.full_messages.first
      redirect_to navigation.back(1)
    end
  end

  def destroy_image
    if ImageDestroyer.new(shop, SHOP_IMAGE_FIELDS).perform(params[:image_field])
      flash[:success] = "Image removed successfully"
    else
      flash[:error] = "Can't remove this image"
    end
    redirect_to navigation.back(1)
  end

  private

  def set_shop
    @shop = Shop.find(params[:id] || params[:shop_id]).decorate
  end

  def set_category
    @category = @shop.categories.first
  end

  def shop_params(shop)
    delocalize_config = { :min_total => :number }

    unless shop.agb
      params.require(:shop).permit!.delocalize(delocalize_config)
    else
      params.require(:shop).permit!.except(:agb).delocalize(delocalize_config)
    end
  end
end
