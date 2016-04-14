class ShopsController <  ApplicationController

  before_action :authenticate_user!, except: [:show]

  before_action :set_shop, except: [:index]

  around_action :set_translation_locale, only: [:update], if: -> {current_user && current_user.role == :admin}

  load_and_authorize_resource

  def index
    @shops = Shop.all
    render :index, layout: "#{current_user.role.to_s}_sublayout"
  end

  def edit_setting
    render :edit_setting, layout: "#{current_user.role.to_s}_sublayout"
  end

  def edit_producer
    render :edit_producer, layout: "#{current_user.role.to_s}_sublayout"
  end

  def show
    @categories_and_children, @categories_and_counters = get_category_values_for_left_menu(@shop.products)

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

  def set_translation_locale
    cl = I18n.locale
    I18n.locale = params[:translation].to_sym if params[:translation]
    yield
    I18n.locale = cl
  rescue
    I18n.locale = cl
  end

  def set_shop
    @shop = Shop.find(params[:id])
  end

  def shop_params(shop)
    delocalize_config = { :min_total => :number }

    unless shop.agb
      params.require(:shop).permit(:shopname, :name, :desc, :logo, :banner, :seal0, :seal1, :seal2, :seal3, :philosophy, :stories, :tax_number, :ustid, :eroi, :min_total, :currency, :status, :founding_year, :register, :website, :agb, sales_channels:[]).delocalize(delocalize_config)
    else
      params.require(:shop).permit(:shopname, :name, :desc, :logo, :banner, :seal0, :seal1, :seal2, :seal3, :philosophy, :stories, :tax_number, :ustid, :eroi, :min_total, :currency, :status, :founding_year, :register, :website, sales_channels:[]).delocalize(delocalize_config)
    end
  end
end