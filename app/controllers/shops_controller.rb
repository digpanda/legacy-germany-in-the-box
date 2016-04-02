class ShopsController <  ApplicationController

  before_action :authenticate_user!, except: [:show]

  load_and_authorize_resource

  def show
    @categories_and_children, @categories_and_counters = get_category_values_for_left_menu(Shop.find(params[:id]).products)
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

         format.html { redirect_to edit_user_path(current_user, :user_info_edit_part => params[:user_info_edit_part]) }
       elsif (not current_user.shop.agb) && current_user.shop.update(sp)
         flash[:success] = I18n.t(:update_agb_ok, scope: :edit_shop)
         format.html { redirect_to edit_user_path(current_user, :user_info_edit_part => :edit_shop) }
       else
        flash[:error] = current_user.shop.errors.full_messages.first
        format.html { redirect_to edit_user_path(current_user, :user_info_edit_part => params[:user_info_edit_part]) }
      end
    end   
  end

  private

  def shop_params
    delocalize_config = { :min_total => :number }

    unless current_user.shop.agb
      params.require(:shop).permit(:shopname, :name, :desc, :logo, :banner, :seal0, :seal1, :seal2, :seal3, :philosophy, :stories, :tax_number, :ustid, :eroi, :min_total, :currency, :status, :founding_year, :register, :website, :agb, sales_channels:[] ).delocalize(delocalize_config)
    else
      params.require(:shop).permit(:shopname, :name, :desc, :logo, :banner, :seal0, :seal1, :seal2, :seal3, :philosophy, :stories, :ustid, :eroi, :min_total, :currency, :status, :founding_year, :register, :website, sales_channels:[] ).delocalize(delocalize_config)
    end
  end
end