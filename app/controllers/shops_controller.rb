class ShopsController <  ApplicationController

  before_action :authenticate_user!, except: [:show]

  before_action :set_shop, except: [:index]

  load_and_authorize_resource

  STRONG_PARAMS = [:shopname, :name, :desc, :logo, :banner, :seal0, :seal1, :seal2, :seal3, :seal4, :seal5, :seal6, :seal7, :philosophy, :stories, :german_essence, :uniqueness, :tax_number, :ustid, :eroi, :min_total, :status, :founding_year, :register, :website, :agb, :fname, :lname, :tel, :mobile, :mail, :function, sales_channels:[]]

  def index
    @shops = Shop.all
    render :index, layout: "sublayout/_#{current_user.role.to_s}"
  end

  def edit_setting
    render :edit_setting, layout: "sublayout/_#{current_user.role.to_s}"
  end

  def edit_producer
    @producer = @shop
    render :edit_producer, layout: "sublayout/_#{current_user.role.to_s}"
  end

  def show_products
    render :show_products, layout: "sublayout/_#{current_user.role.to_s}"
  end

  def apply_wirecard

  end

  def show
    @categories_and_children, @categories_and_counters = AppCache.get_category_values_for_left_menu(@shop.products)

    respond_to do |format|
      format.html { render :show }
      format.json { render :show }
    end
  end

  def update
    respond_to do |format|
      sp = shop_params(@shop)

      if @shop.agb && @shop.update(sp)
        if params[:user_info_edit_part] == :edit_producer.to_s
          flash[:success] = I18n.t(:update_producer_ok, scope: :edit_shop)
        else
          flash[:success] = I18n.t(:update_ok, scope: :edit_shop)
        end

        format.html {
          redirect_to request.referer
        }
      elsif (not @shop.agb) && @shop.update(sp)
        flash[:success] = I18n.t(:update_agb_ok, scope: :edit_shop)

        format.html { redirect_to edit_setting_shop_path(@shop, :user_info_edit_part => :edit_shop) }
      else
        flash[:error] = @shop.errors.full_messages.first

        format.html {
          redirect_to request.referer
        }
      end
    end
  end

  def destroy
    if @shop.addresses.delete_all && (@shop.bank_account ? @shop.bank_account.delete : true) && @shop.destroy
      flash[:success] = I18n.t(:delete_ok, scope: :edit_shops)
    else
      flash[:error] = @shop_application.errors.full_messages.first
    end

    redirect_to request.referer
  end

  private

  def set_shop
    @shop = Shop.find(params[:id]).decorate
  end

  def shop_params(shop)
    delocalize_config = { :min_total => :number }

    unless shop.agb
      params.require(:shop).permit(*STRONG_PARAMS).delocalize(delocalize_config)
    else
      params.require(:shop).permit(*STRONG_PARAMS).except(:agb).delocalize(delocalize_config)
    end
  end
end