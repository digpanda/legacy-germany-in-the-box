class ShopsController <  ApplicationController

  before_action :authenticate_user!, except: [:show]

  load_and_authorize_resource

  def index
    @shops = Shop.all
    render :index, layout: "#{current_user.role.to_s}_sublayout"
  end

  def edit_setting
    @shop = current_user.shop
    render :edit_setting, layout: 'shopkeeper_sublayout'
  end

  def edit_producer
    @shop = current_user.shop
    render :edit_producer, layout: 'shopkeeper_sublayout'
  end

  def show
    @shop = Shop.find(params[:id])
    @categories_and_children, @categories_and_counters = get_category_values_for_left_menu(@shop.products)

    respond_to do |format|
      format.html { render :show }
      format.json { render :show }
    end
  end

  def update
     respond_to do |format|
       sp = shop_params

       if current_user.shop.agb && current_user.shop.update(sp)
         if params[:user_info_edit_part] == :edit_producer.to_s
           flash[:success] = I18n.t(:update_producer_ok, scope: :edit_shop)
         else
           flash[:success] = I18n.t(:update_ok, scope: :edit_shop)
         end

         format.html {
           if :edit_shop.to_s ==  params[:user_info_edit_part]
             redirect_to edit_setting_shop_path(current_user, :user_info_edit_part => :edit_shop)
           elsif :edit_producer.to_s == params[:user_info_edit_part]
             redirect_to edit_producer_shop_path(current_user, :user_info_edit_part => :edit_producer)
           end
         }
       elsif (not current_user.shop.agb) && current_user.shop.update(sp)
         flash[:success] = I18n.t(:update_agb_ok, scope: :edit_shop)

         format.html { redirect_to edit_setting_shop_path(current_user, :user_info_edit_part => :edit_shop) }
       else
        flash[:error] = current_user.shop.errors.full_messages.first

        format.html {
          if :edit_shop.to_s ==  params[:user_info_edit_part]
            redirect_to edit_setting_shop_path(current_user, :user_info_edit_part => :edit_shop)
          elsif :edit_producer.to_s == params[:user_info_edit_part]
            redirect_to edit_producer_shop_path(current_user, :user_info_edit_part => :edit_producer)
          end
        }
      end
    end   
  end

  private

  def shop_params
    delocalize_config = { :min_total => :number }

    unless current_user.shop.agb
      params.require(:shop).permit(:shopname, :name, :desc, :logo, :banner, :seal0, :seal1, :seal2, :seal3, :philosophy, :stories, :tax_number, :ustid, :eroi, :min_total, :currency, :status, :founding_year, :register, :website, :agb, sales_channels:[] ).delocalize(delocalize_config)
    else
      params.require(:shop).permit(:shopname, :name, :desc, :logo, :banner, :seal0, :seal1, :seal2, :seal3, :philosophy, :stories, :tax_number, :ustid, :eroi, :min_total, :currency, :status, :founding_year, :register, :website, sales_channels:[] ).delocalize(delocalize_config)
    end
  end
end